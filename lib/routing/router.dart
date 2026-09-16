import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

Page<void> _page(GoRouterState state, Widget child) {
  return MaterialPage<void>(key: state.pageKey, name: state.name, child: child);
}

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final _channelsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'channels');
final _dmsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'dms');
final _moreNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'more');

GoRouter createRouter({
  required AuthRepository authRepository,
  String initialLocation = Routes.home,
  bool debugLogDiagnostics = false,
}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    debugLogDiagnostics: debugLogDiagnostics,
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
    redirect: (context, state) {
      final signedIn = authRepository.isSignedIn;
      final goingToSignIn = state.matchedLocation == Routes.signIn;
      if (!signedIn) return goingToSignIn ? null : Routes.signIn;
      return goingToSignIn ? Routes.home : null;
    },
    routes: [
      GoRoute(
        path: Routes.signIn,
        pageBuilder: (context, state) => _page(state, const SignInScreen()),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) =>
            _page(state, HomeScreen(navigationShell: navigationShell)),
        branches: [
          StatefulShellBranch(
            navigatorKey: _channelsNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.channels,
                pageBuilder: (context, state) =>
                    _page(state, const ChannelsScreen()),
                routes: [
                  GoRoute(
                    path: Routes.channelDetailRelative,
                    parentNavigatorKey: rootNavigatorKey,
                    pageBuilder: (context, state) => _page(
                      state,
                      ChannelDetailScreen(
                        channelId: state.pathParameters['channelId']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _dmsNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.dms,
                pageBuilder: (context, state) =>
                    _page(state, const DmsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _moreNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.more,
                pageBuilder: (context, state) =>
                    _page(state, const MoreScreen()),
                routes: [
                  GoRoute(
                    path: Routes.moreSettingsRelative,
                    pageBuilder: (context, state) =>
                        _page(state, const MoreSettingsScreen()),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
