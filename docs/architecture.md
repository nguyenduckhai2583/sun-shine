# Architecture

This app follows
[docs.flutter.dev/app-architecture/recommendations](https://docs.flutter.dev/app-architecture/recommendations)
verbatim. Every recommendation on that page is tracked below, with where it
lives in this repo.

## Layout

```
lib/
├── core.dart                     the single barrel every file imports
├── config/                       build config, env, DI wiring
├── data/
│   ├── services/                 one class per external dependency (the API)
│   └── repositories/             source of truth; maps API -> domain
├── domain/models/                immutable models the UI speaks (freezed)
├── routing/                      paths (routes.dart) + tree (router.dart)
├── ui/
│   ├── core/                     shared themes + widgets
│   └── <feature>/
│       ├── view_models/          ChangeNotifier + Command
│       └── widgets/              dumb Views
└── utils/                        Result, Command
```

Data flows one way: `service -> repository -> view model -> view`. Events go
back the other way only as method calls on the ViewModel.

## Recommendation checklist

| # | Recommendation | Level | Where |
|---|---|---|---|
| 1 | Clearly defined data and UI layers | Strongly | `lib/data/` vs `lib/ui/` |
| 2 | Repository pattern in the data layer | Strongly | `WorkspaceRepository` + `WorkspaceApiClient` |
| 3 | ViewModels and Views (MVVM) | Strongly | `HomeViewModel` / `HomeScreen`, `HomeDrawer` |
| 4 | `ChangeNotifier`/`Listenable` for widget updates | Conditional | `HomeViewModel extends ChangeNotifier`; `ListenableBuilder` in `HomeDrawer` |
| 5 | No logic in widgets | Strongly | Views only branch on VM flags; `selectWorkspace` lives on the VM |
| 6 | Domain layer (use cases) | Conditional | **Skipped on purpose** — see below |
| 7 | Unidirectional data flow | Strongly | see above |
| 8 | `Command`s for user events | Recommend | `lib/utils/command.dart`; `HomeViewModel.load` |
| 9 | Immutable data models | Strongly | `Workspace`, `WorkspaceApiModel` |
| 10 | `freezed`/`built_value` to generate them | Recommend | `freezed` — run `build_runner` after editing a model |
| 11 | Separate API and domain models | Conditional | `WorkspaceApiModel` vs `Workspace`, mapped in the repository |
| 12 | Dependency injection | Strongly | `provider`; `lib/config/dependencies.dart` |
| 13 | `go_router` for navigation | Recommend | `lib/routing/`; see [routing.md](routing.md) |
| 14 | Standard naming for classes/files/dirs | Recommend | `HomeViewModel`, `HomeScreen`, `WorkspaceRepository`; shared widgets in `ui/core/`, not `/widgets` |
| 15 | Abstract repository classes | Strongly | `WorkspaceRepository` is abstract; `WorkspaceRepositoryRemote` implements it |
| 16 | Test components separately and together | Strongly | unit tests per service/repository/ViewModel + widget tests covering routing and DI |
| 17 | Make fakes for testing | Strongly | `test/testing/fakes/` |

### Observable data and the single source of truth

A repository returns `Result` for one-off reads and writes. It does **not**
notify. When several screens must see the same entity change, the observable
lives in a separate local service:

```
ChannelApiClient      the network
ChannelLocalService   BehaviorSubject<List<Channel>> — the source of truth
ChannelRepository     orchestrates both; exposes streams + Result methods
ChannelsViewModel     subscribes to repository.channels
ChannelDetailViewModel subscribes to repository.watchChannel(id)
```

Renaming a channel writes through the API, upserts into the local service, and
both view models update from the stream. No pop result, no manual refresh —
there is a test asserting the list view model sees the new name while the detail
screen is still open.

`ChannelLocalService` dedupes (`if (current[index] == channel) return;`) and
`watch(id)` ends in `.distinct()`, so an unchanged value never wakes the UI.

This is the shape used by the apps surveyed for this decision:

| App | Source of truth | Mechanism |
|---|---|---|
| employer-mobile | in-memory local service | `BehaviorSubject` + `.distinct()` |
| [Immich](https://github.com/immich-app/immich) | local DB (drift) | `.watch()` / `.watchSingleOrNull()` |
| [AppFlowy](https://github.com/AppFlowy-IO/AppFlowy) | Rust backend | notification stream → per-entity listener |

None of them make the repository itself a `Listenable`.

### Module scopes, and why planix uses `ShellRoute`

Planix opens full-screen from the More tab and spans two routes — `/planix` and
`/planix/:projectId` — that must share one `ProjectLocalService`.

Nesting them under `routes:` looks like it should be enough. It is not. Every
`GoRoute` produces its own `Page`, and a `Navigator` holds pages in a stack, so
nested routes are **sibling pages, not parent and child widgets**. Printing the
ancestor chain of a detail screen shows the parent list screen is absent:

```
Navigator                                    <- directly above the detail page
_InheritedProviderScope<ChannelRepository?>  <- data layer, above the navigator
AuthScope
...
ChannelsScreen in the ancestor chain? false
```

`context.read<T>()` walks *up the element tree*, so it can never reach sideways
into a sibling page. Nesting `routes:` buys a nested URL and the right stack
order — never a shared ancestor.

That leaves exactly two places a module's data layer can live: above the root
navigator (`appProviders`), or inside a shell. `ShellRoute` is the only
go_router construct that makes one widget a real ancestor of several routes,
because its builder receives the nested `Navigator` as `child`:

```dart
ShellRoute(
  builder: (context, state, child) =>
      MultiProvider(providers: planixModuleProviders, child: child),
  routes: [
    GoRoute(
      path: Routes.planix,
      routes: [GoRoute(path: Routes.planixProjectRelative, ...)],
    ),
  ],
)
```

The scope is disposed by the framework when the module is popped — no
per-module cleanup line to remember.

This replaces an earlier flat-route shape that kept `planixModuleProviders` in
`appProviders` and cleared it by hand:

```dart
onExit: (context, state) {
  context.read<ProjectRepository>().invalidateCache();
  return true;
}
```

That worked, but it leaked module state into the session scope and cost a line
per module. It also could not survive moving the providers onto the route:
go_router hands `onExit` the **root navigator's** context
(`delegate.dart`, `_callOnExitStartsAt(context: navigatorContext)`), which sits
above any page-level provider, so the `read` stops resolving.

The one cost is real: `ShellRoute` always builds a nested `Navigator`, so
`/planix` is the first route in it, `Navigator.canPop` is false, and `AppBar`
does not imply a back button on the **entry page only** — the detail page still
gets one automatically. The fix is one line, and `context.pop()` is the plain
go_router idiom, not a hand-wired root-navigator call, because
`_findCurrentNavigators()` returns `[shell, root]` and pops the first navigator
that can:

```dart
AppBar(leading: BackButton(onPressed: () => context.pop()), ...)
```

This is the same conclusion the ecosystem reached. `go_provider` exists purely
to fill this gap, and its `GoProviderRoute` is a `ShellRoute` subclass wrapping
`Nested` (what `MultiProvider` extends) — it even ships a `GoPopButton` whose
`onPressed` defaults to `context.pop`, for exactly this entry-page case.
go_router's own proposal to scope providers to paths
([csells/go_router#185](https://github.com/csells/go_router/issues/185)) was
never resolved before the repo was archived.

### Clearing data on sign-out

Two scopes, nested:

```
authProviders        AuthApiClient, AuthLocalService, AuthRepository
└── AuthScope        StreamBuilder on the session; key: ValueKey(userId)
    └── appProviders ChannelApiClient, ChannelLocalService, ChannelRepository
        └── MainApp  MaterialApp.router
```

Signing out drops the session, the key flips to `_anonymous`, the subtree
unmounts, and every `Provider.dispose` runs — `ChannelLocalService.dispose()`
closes its `BehaviorSubject`. Switching accounts flips the key to the new user
id, so the whole session scope is rebuilt from scratch.

Nothing has to be remembered. Adding a feature cache to `channelDataProviders`
gets clear-on-sign-out for free.

Both apps surveyed clear manually instead, and pay for it:

- **employer-mobile** — `SessionManager.cleanSession()` enumerates every cache,
  plus a dedicated `PulseWorkspaceGuard` registered app-wide purely to call
  `clear()` on three local services when the workspace changes. Nothing is
  disposed automatically because the GetX singletons are `permanent`.
- **[Immich](https://github.com/immich-app/immich)** — `AuthService.clearLocalData()`
  enumerates `_authRepository.clearLocalData()`, `Store.delete(...)`,
  `SettingsRepository.instance.clear([...])`.

Manual clearing is still needed for state that lives **outside** the widget
tree — tokens in secure storage, a local DB, an open socket, delivered
notifications. That list is short and stable; the in-memory caches are the part
that grows, and scope handles those.

`test/ui/auth/widgets/auth_flow_test.dart` pins the behaviour: sign-out disposes
`ChannelLocalService`, and a second user gets fresh instances.

### Routing and auth

`createRouter` takes the `AuthRepository` and redirects on every navigation:

```dart
redirect: (context, state) {
  final signedIn = authRepository.isSignedIn;
  final goingToSignIn = state.matchedLocation == Routes.signIn;
  if (!signedIn) return goingToSignIn ? null : Routes.signIn;
  return goingToSignIn ? Routes.home : null;
},
```

There is deliberately no `refreshListenable`: `AuthScope` re-keys on every
session change, which rebuilds `MainApp` and therefore the router. Adding a
refresh listener as well would make the same transition fire twice.

### Instance lifecycle logging

`package:provider` has no observer hook — that is Riverpod's `ProviderObserver`
— and `ChangeNotifier` has none either: it is a `mixin class` with no
constructor, so there is nothing to notify from. The seam therefore lives on the
objects, not on the registration. `lib/utils/di.dart` defines a `DiObserver` and
one base class per layer that reports through it, exactly the way `BlocBase`
reports through `Bloc.observer`:

- `BaseViewModel extends ChangeNotifier` — reports creation and disposal.
- `BaseApiClient` — reports creation only.
- `BaseRepo` — reports creation only.
- `BaseLocalService` — reports creation and disposal; it is the only
  data-layer object that owns a resource.

Registration sites are plain `provider` API, with no wrapper to learn:

```dart
Provider(create: (context) => ChannelApiClient()),
Provider(
  create: (context) => ChannelLocalService(),
  dispose: (context, service) => service.dispose(),
),
ChangeNotifierProvider(
  create: (context) => ChannelsViewModel(channelRepository: context.read()),
),
```

Output is one line per event, with the identity hash so the same instance can be
matched across create and dispose:

```
[di] ChannelLocalService created
[di] ChannelLocalService deleted
```

`main.dart` installs the observer with `Di.observer = const DiLog()`; until then
it is silent. `DiLog.enabled` defaults to `kDebugMode` and `main.dart` sets it
from `BuildConfig().isDebug`. `DiLog.output` swaps the sink — leave it null for
`debugPrint`, or point it at a real logger. Because `DiLog` is just one
`DiObserver`, a test spy or leak detector can replace it without touching a
single registration.

`BaseApiClient` and `BaseRepo` deliberately declare nothing but a constructor. A
constructor is not part of a class's implicit interface, so the fakes in
`test/testing/fakes/` keep saying `implements ChannelApiClient` with nothing
extra to stub out. `BaseLocalService` can afford a `dispose()` because nothing
fakes a local service by interface; its subclasses override it, close their
stream, and call `super`.

Framework objects such as `ScrollController` are deliberately not covered.
`FlutterMemoryAllocations` would catch those, but it only sees `ChangeNotifier`
subclasses, dispatches creation lazily on the first `addListener` rather than at
construction, and is assert-gated — a ViewModel created but never watched would
emit no events at all, which is exactly the instance worth catching.

### Dependency scopes

There is no root `MultiProvider`. Each screen that needs dependencies mounts its
own scope and delegates to a private view:

| Scope | Mounted by | Contains |
|---|---|---|
| auth | `main.dart` (`authProviders`) | `AuthApiClient`, `AuthLocalService`, `AuthRepository` |
| session | `AuthScope` (`appProviders`), keyed by user id | `ChannelApiClient`, `ChannelLocalService`, `ChannelRepository` |
| home | `HomeScreen` | `WorkspaceApiClient`, `WorkspaceRepository`, `HomeViewModel` |
| channels | `ChannelsScreen` | `ChannelsViewModel` |
| channel detail | `ChannelDetailScreen` | `ChannelDetailViewModel` |
| planix module | `ShellRoute` in `router.dart` | `ProjectApiClient`, `ProjectLocalService`, `ProjectRepository` |
| planix projects | `PlanixProjectsScreen` | `PlanixProjectsViewModel` |
| planix detail | `PlanixProjectDetailScreen` | `PlanixProjectDetailViewModel` |

Data that several screens must agree on lives above them — at the session
root when the whole app needs it, or in a module `ShellRoute` when only one
feature does; view models stay per-screen. `appProviders` composes feature-owned lists (`channelDataProviders`)
rather than listing every dependency itself, so it stays one line per feature.

A provider list is a plain function, so a scope that depends on route
parameters just takes them as arguments — `channelProviders(channelId)` versus
`homeProviders`.

Scope reach follows the element tree, not the route tree. Anything rendered
inside the home shell — the tab screens, the drawer, and nested routes such as
`/more/settings` — can read the home scope. A route that escapes to the root
navigator (`parentNavigatorKey: rootNavigatorKey`) is a *sibling* of
`HomeScreen`, not a descendant, so it cannot. `ChannelDetailScreen` is in that
position, which is exactly why it owns its data end to end and deep links
straight to `/channels/general` with no `extra` and no parent scope. There is a
test for each half of that.

The cost is that two scopes holding the same repository type hold separate
caches. Move a repository up only when scopes genuinely must share one.

### On #6 — no domain layer

The page marks use cases *Conditional*: "only needed if your application has
exceedingly complex logic that crowds your ViewModels, or if you find yourself
repeating logic in ViewModels. In very large apps, use-cases are useful, but in
most apps they add unnecessary overhead."

Nothing here qualifies yet. When logic starts repeating across ViewModels, add
`lib/domain/use_cases/` and move it there — the layer slots in between
ViewModels and repositories without touching either boundary.

## Material

The app imports `package:material_ui/material_ui.dart`, not
`package:flutter/material.dart`. `material_ui` is the official Material library
decoupled out of the Flutter SDK into `flutter/packages`; go_router 18 and the
rest of the ecosystem have moved to it.

Migration is a data-driven dart fix:

```bash
fvm dart fix --apply --code=migrate_design_widgets
```

Two follow-ups from the package README that do **not** apply here, but will if
things change:

- **Localizations.** Using `GlobalMaterialLocalizations` means taking it from
  `material_ui` rather than `flutter_localizations`
  (`localizationsDelegates: GlobalMaterialLocalizations.delegates`).
- **Legacy dependencies.** A third-party package still importing
  `package:flutter/material.dart` needs its subtree wrapped in
  `MaterialUiCompatibilityBridge` so `ThemeData` and `MaterialLocalizations`
  resolve. No current dependency needs this.

## Code generation

`freezed` and `json_serializable` generate `*.freezed.dart` and `*.g.dart`.
They are committed (same convention as employer-mobile), so a fresh clone
builds without running anything.

After editing any model:

```bash
fvm dart run build_runner build
# or, while iterating:
fvm dart run build_runner watch
```

The analyzer skips generated files (`analysis_options.yaml`), and
`invalid_annotation_target` is downgraded to `ignore` as the freezed docs
require when combined with `json_serializable`.

## State management

ViewModels are `ChangeNotifier`s. Views observe them two ways:

- `context.watch<T>()` / `context.select<T, R>()` — rebuild on change.
  `select` is preferred where only one field matters; `_Title` in
  `tab_scaffold.dart` uses it so the app bar does not rebuild on every notify.
- `ListenableBuilder` — scope a rebuild to a subtree. `HomeDrawer` listens to
  `viewModel.load` (the `Command`, not the whole VM) so only the list rebuilds
  when loading finishes.

Actions that can fail are `Command`s rather than hand-rolled `isLoading` flags.
A `Command` exposes `running`, `completed`, `error` and `result`, and refuses to
start twice concurrently — which is what kills the double-tap class of bug.

Repositories and services return `Result<T>` (`Ok` / `Error`), so a caller
cannot forget the failure path; the `switch` is exhaustive.

> Note: `Error` here is `lib/utils/result.dart`'s, not `dart:core`'s. It comes
> through `core.dart`, so inside this app `Error` means the Result variant.

## Testing

```bash
fvm flutter test
```

- **Services** — `test/data/workspace_api_client_test.dart`
- **Models** — `test/data/workspace_api_model_test.dart` (JSON round-trip)
- **Repositories** — `test/data/workspace_repository_remote_test.dart`, driven
  by `FakeWorkspaceApiClient`, covering mapping, failure and caching
- **ViewModels** — `test/ui/home/view_models/home_viewmodel_test.dart`
- **Commands** — `test/utils/command_test.dart`
- **Views, routing and DI** — `test/ui/home/widgets/home_screen_test.dart` boots
  the real `createRouter()` over a fake repository, and
  `test/config/dependencies_test.dart` asserts `providersRemote` resolves the
  repository by its abstract type

Fakes live in `test/testing/fakes/` and are shared across suites.
