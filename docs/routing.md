# How go_router works in this app

## 1. The mental model

Without go_router you push widgets:

```dart
Navigator.push(context, MaterialPageRoute(builder: (_) => ChannelScreen()));
```

With go_router you name a **location** (a URL) and the router decides which
widgets to build:

```dart
context.go('/channels/general');
```

That inversion is the whole point. A URL can come from a button, from a
notification tap, from a deep link, or from the browser address bar — the router
handles all four identically. `MaterialApp.router(routerConfig: ...)` in
`lib/main.dart` is what hands navigation over.

## 2. The route tree

`lib/routing/router.dart` declares the tree once, at startup:

```
StatefulShellRoute.indexedStack        <- builds HomeScreen (drawer + nav bar)
├── branch 0  /channels                <- ChannelsScreen
│              └── :channelId          <- ChannelDetailScreen  (root navigator)
├── branch 1  /dms                     <- DmsScreen
└── branch 2  /more                    <- MoreScreen
               └── settings            <- MoreSettingsScreen   (branch navigator)
```

Paths are the source of truth. `lib/routing/routes.dart` holds them as constants
so no call site hard-codes a string.

## 3. Why `StatefulShellRoute`, and what "stateful" buys you

Three route types matter:

| Type | What it does |
|---|---|
| `GoRoute` | maps one path to one screen |
| `ShellRoute` | wraps children in shared UI, **one** navigator |
| `StatefulShellRoute` | wraps children in shared UI, **one navigator per branch** |

The "shell" is `HomeScreen`: the `Scaffold` holding the drawer and the
`NavigationBar`. It is built once and stays mounted while you move between tabs,
which is why the drawer does not rebuild on every tab change.

The app bar belongs to each tab, not the shell — every branch root wraps its
body in `TabScaffold`, which supplies the title and the drawer button. That is
what lets a nested page such as `/more/settings` bring its own `AppBar` (with an
automatic back button) instead of stacking a second bar under the shell's.

`TabScaffold` resolves the drawer from the context *above* its own `Scaffold`:

```dart
onPressed: () => Scaffold.of(context).openDrawer(),
```

`context` there is `TabScaffold`'s, which sits below the shell `Scaffold` and
above the one it returns — so the lookup finds the shell's drawer. Calling
`Scaffold.of` from inside the tab's own `Scaffold` would find that one instead,
which has no drawer.

"Stateful" means each tab gets its own `Navigator` (`_channelsNavigatorKey`,
`_dmsNavigatorKey`, `_moreNavigatorKey`). Consequences:

- Each tab keeps its own back-stack. Go three screens deep in Channels, switch
  to More, come back — you are still three deep.
- `indexedStack` keeps all three branches alive in an `IndexedStack`, so scroll
  positions and in-progress form state survive a tab switch.

Switching tabs is not `context.go`, it is:

```dart
navigationShell.goBranch(
  index,
  initialLocation: index == navigationShell.currentIndex, // re-tap pops to root
);
```

`navigationShell` is both the widget that renders the active branch *and* the
controller that switches branches.

## 4. `parentNavigatorKey`: the one line that changes everything

`/channels/:channelId` is declared as a child of `/channels`, but with:

```dart
parentNavigatorKey: rootNavigatorKey,
```

| With that line | Without it |
|---|---|
| pushed on the **root** navigator | pushed on the **branch** navigator |
| covers the whole shell — no nav bar, no drawer | renders inside the shell, nav bar stays visible |
| right for detail pages, modals, media viewers | right for master-detail inside one tab |

The app ships one of each, so you can compare them by hand:

| Route | Key | Behaviour |
|---|---|---|
| `/channels/:channelId` | `parentNavigatorKey: rootNavigatorKey` | full-screen, tab bar hidden |
| `/more/settings` | omitted | **nested navigation** — tab bar stays |

Nested navigation is the reason to reach for `StatefulShellRoute` over a plain
`ShellRoute`: `/more/settings` lands in the **More branch's own back stack**, so
you can open it, walk over to Channels, come back, and still be on Settings.
A `BackButton` there pops within the tab rather than out of the app.

Both behaviours are pinned by tests in
`test/ui/home/widgets/home_screen_test.dart` — "pushing the detail route covers
the tab bar" for the full-screen case, and the `nested navigation in the More
tab` group for the other.

One structural constraint: a route can only escape to the root navigator if it
is a **nested child** of another route (inside a parent's `routes:`). Declared
as a direct sibling in a branch, go_router asserts that a sub-route's
`parentNavigatorKey` must be null or equal the branch's key.

## 5. Path parameters

`:channelId` matches any single segment. The value arrives in the builder:

```dart
GoRoute(
  path: ':channelId',                                   // -> /channels/general
  builder: (context, state) =>
      ChannelDetailScreen(channelId: state.pathParameters['channelId']!),
)
```

The screen receives a plain `String`, so `ChannelDetailScreen` has no dependency
on go_router and can be widget-tested on its own.

Query parameters work the same way via `state.uri.queryParameters`
(`/channels?filter=unread`).

## 6. Navigating

| Call | Effect |
|---|---|
| `context.go('/dms')` | **replaces** the stack — use for tabs and top-level jumps |
| `context.push('/channels/general')` | **pushes** — keeps the back button |
| `context.pop()` | back |
| `context.replace('/more')` | swaps the top entry without growing the stack |

Prefer `Routes.channelDetail('general')` over a literal so the path shape lives
in one file. A restructure of `/channels/:channelId` then means editing that one
helper, not every call site.

go_router also supports name-based navigation (`GoRoute(name: ...)` plus
`context.goNamed` / `pushNamed`). This app does not use it: the `Routes` helpers
already keep URL shapes out of call sites, so names would be a second mechanism
for the same job. Add `name:` when something actually needs it — screen-tracking
analytics in a `NavigatorObserver` is the usual trigger, since `GoRouterState.name`
is a better key than a raw path.

## 7. Page transitions

Every route uses `pageBuilder:` with an explicit `MaterialPage`:

```dart
Page<void> _page(GoRouterState state, Widget child) =>
    MaterialPage<void>(key: state.pageKey, name: state.name, child: child);
```

Pushes animate for 450ms — `PredictiveBackPageTransitionsBuilder`, the Android
default in Flutter 3.47. iOS gets `CupertinoPageTransitionsBuilder`.

`test/routing/router_test.dart` pins this: pushed routes must be a
`MaterialRouteTransitionMixin` with a non-zero duration, and the incoming page
must genuinely be mid-flight one frame in.

### Why explicit, and the trap it avoids

With `builder:`, go_router picks the page type by sniffing the tree for a
`MaterialApp` (`findAncestorWidgetOfExactType`, an exact type match). go_router
18 migrated to `package:material_ui`, so it looks for **that** package's
`MaterialApp`.

While this app still imported `package:flutter/material.dart`, that check failed
silently — different class, no match — and every push fell back to
`NoTransitionPage`:

```
_CustomTransitionPageRoute   transitionDuration = 0ms
```

The app has since migrated to `material_ui`, so the sniffing works and `builder:`
would now produce a `MaterialPage` by itself. The explicit `pageBuilder:` is kept
anyway: it does not depend on ancestor-type detection, and a custom transition
(`CustomTransitionPage`) needs `pageBuilder:` regardless.

Switching tabs is a separate matter and is **never** animated:
`StatefulShellRoute.indexedStack` swaps the `IndexedStack` child directly. The
~600ms you can observe on a tab tap is the `NavigationBar`'s own indicator
animation, not a page transition. Animated branch switching needs a custom
`navigatorContainerBuilder`.

To customise a transition, swap `MaterialPage` for `CustomTransitionPage` in
`_page`, or per route.

## 8. Errors

`errorBuilder` catches any location that matches nothing and renders
`ErrorScreen`. Turn on `debugLogDiagnostics: true` (already wired to
`BuildConfig().isDebug`, so it is on for dev builds) and every navigation prints
the matched route — the fastest way to see why a path did not resolve.

## 9. Adding a route — the checklist

1. Add the path constant to `lib/routing/routes.dart`, with a helper function
   if it takes parameters.
2. Add the `GoRoute` to `lib/routing/router.dart`, inside the branch it belongs
   to, using `pageBuilder: (context, state) => _page(state, ...)`. Decide:
   full-screen (`parentNavigatorKey: rootNavigatorKey`) or inside the shell
   (omit it).
3. Build the screen under `lib/ui/<feature>/widgets/`, taking plain values —
   never `GoRouterState` — as constructor arguments.
4. Export it from the feature barrel (`lib/ui/<feature>/<feature>.dart`).
5. Add a test that pumps `createRouter(initialLocation: ...)`.

## 10. Not wired up yet

- **Auth redirect.** `GoRouter` takes a `redirect` callback that runs on every
  navigation; the usual shape is "if signed out and not already on `/sign-in`,
  return `/sign-in`". Combine it with `refreshListenable` pointed at an auth
  `ChangeNotifier` so the router re-evaluates the moment the session changes.
- **Deep links.** The route tree already accepts them; the native side
  (`AndroidManifest.xml` intent filter, iOS `Info.plist` +
  `Runner.entitlements` + `apple-app-site-association`) is not configured.
- **Web.** Call `usePathUrlStrategy()` in `main.dart` and add
  `flutter_web_plugins` when a web target is added, to drop the `#` from URLs.
