import 'package:material_ui/material_ui.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sun_shine/core.dart';

Page<void> _page(GoRouterState state, Widget child) {
  return MaterialPage<void>(key: state.pageKey, name: state.name, child: child);
}

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final _channelsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'channels');
final _dmsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'dms');
final _moreNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'more');

GoRouter createRouter({
  required SessionManager sessionManager,
  required SignInFlowUseCase signInFlowUseCase,
  String initialLocation = Routes.splash,
  bool debugLogDiagnostics = false,
}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    debugLogDiagnostics: debugLogDiagnostics,
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
    refreshListenable: GoRouterRefreshStream(
      Rx.merge<dynamic>([
        sessionManager.activeSession,
        sessionManager.restored,
        signInFlowUseCase.addingAccount,
      ]),
    ),
    redirect: (context, state) => sessionRedirect(
      session: sessionManager.currentSession,
      isRestored: sessionManager.isRestored,
      isAddingAccount: signInFlowUseCase.isAddingAccount,
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: Routes.splash,
        pageBuilder: (context, state) => _page(state, const SplashScreen()),
      ),
      GoRoute(
        path: Routes.signIn,
        pageBuilder: (context, state) => _page(state, const SignInScreen()),
      ),
      GoRoute(
        path: Routes.workspace,
        pageBuilder: (context, state) => _page(state, const WorkspaceScreen()),
      ),
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

String? sessionRedirect({
  required Session? session,
  required bool isRestored,
  required String location,
  bool isAddingAccount = false,
}) {
  if (!isRestored) {
    return location == Routes.splash ? null : Routes.splash;
  }
  // Adding an account opens sign-in while another account stays signed in.
  if (isAddingAccount) {
    return location == Routes.signIn ? null : Routes.signIn;
  }
  if (session == null) {
    return location == Routes.signIn ? null : Routes.signIn;
  }
  if (session.needsWorkspace) {
    return location == Routes.workspace ? null : Routes.workspace;
  }
  if (location == Routes.signIn ||
      location == Routes.workspace ||
      location == Routes.splash) {
    return Routes.home;
  }
  return null;
}
