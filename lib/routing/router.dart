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
  required SessionRepository sessionRepository,
  String initialLocation = Routes.home,
  bool debugLogDiagnostics = false,
}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    debugLogDiagnostics: debugLogDiagnostics,
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
    // Without this the redirect only re-runs on navigation. Signing in happens
    // to work anyway, because AuthScope's ValueKey rebuilds the whole app — but
    // picking a workspace does not change the user id, so nothing would move.
    refreshListenable: GoRouterRefreshStream(sessionRepository.activeSession),
    redirect: (context, state) => sessionRedirect(
      session: sessionRepository.currentSession,
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: Routes.signIn,
        pageBuilder: (context, state) => _page(state, const SignInScreen()),
      ),
      // A placeholder until the workspace-picker screen is ported; the redirect
      // above already routes here when an account has no workspace.
      GoRoute(
        path: Routes.workspace,
        pageBuilder: (context, state) => _page(
          state,
          const Scaffold(
            body: PlaceholderTab(
              icon: Icons.workspaces_outline,
              title: 'Workspace',
              message: 'Choosing a workspace lands here.',
            ),
          ),
        ),
      ),
      // Nested GoRoutes are sibling pages on one navigator, not parent/child
      // widgets, so a provider inside /planix is invisible to /planix/:id. The
      // shell is the only ancestor both reach; popping it disposes the scope.
      ShellRoute(
        builder: (context, state, child) => MultiProvider(
          providers: [
            Provider(create: (context) => ProjectApiClient()),
            Provider(
              create: (context) => ProjectLocalService(),
              dispose: (context, service) => service.dispose(),
            ),
            Provider<ProjectRepository>(
              create: (context) => ProjectRepositoryImpl(
                apiClient: context.read(),
                localService: context.read(),
              ),
            ),
          ],
          child: child,
        ),
        routes: [
          GoRoute(
            path: Routes.planix,
            pageBuilder: (context, state) =>
                _page(state, const PlanixProjectsScreen()),
            routes: [
              GoRoute(
                path: Routes.planixProjectRelative,
                pageBuilder: (context, state) => _page(
                  state,
                  PlanixProjectDetailScreen(
                    projectId: state.pathParameters['projectId']!,
                  ),
                ),
              ),
            ],
          ),
        ],
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
