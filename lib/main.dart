import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BuildConfig().setupEnvironment();
  Di.observer = const DiLog();
  DiLog.enabled = BuildConfig().isDebug;
  LogUtils.init(isDebug: BuildConfig().isDebug);

  await AppDatabase.instance.open();

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) =>
              AuthManager(baseUrl: BuildConfig().env.baseApiUrl),
        ),
        Provider(create: (context) => AuthLocalService()),
        Provider(create: (context) => WorkspaceLocalService()),
        Provider<SessionRepository>(
          create: (context) =>
              SessionRepositoryImpl(localService: context.read()),
        ),
        // Shared authed client: token and workspace header follow whichever
        // account is active, so every service built on it switches with them.
        Provider<Dio>(
          create: (context) => AppDio.create(
            baseUrl: BuildConfig().env.baseApiUrl,
            sessionRepository: context.read(),
          ),
        ),
        Provider(create: (context) => WorkspaceApiClient(context.read())),
        Provider<WorkspaceRepository>(
          create: (context) => WorkspaceRepositoryImpl(
            apiClient: context.read(),
            localService: context.read(),
          ),
        ),
        Provider(
          create: (context) =>
              SessionManager(sessionRepository: context.read()),
        ),
        Provider<AuthRepository>(
          create: (context) =>
              AuthRepositoryImpl(client: AuthApiClient(context.read())),
        ),
        Provider(
          create: (context) => TokenRefreshApiClient(
            DioFactory.create(baseUrl: BuildConfig().env.baseApiUrl),
          ),
        ),
        Provider(
          create: (context) => SignInFlowUseCase(authManager: context.read()),
        ),
        Provider(
          create: (context) => SwitchAccountUseCase(
            sessionRepository: context.read(),
            workspaceRepository: context.read(),
            tokenRefreshApiClient: context.read(),
          ),
        ),
        Provider(
          create: (context) => SelectWorkspaceUseCase(
            sessionRepository: context.read(),
            switchAccountUseCase: context.read(),
          ),
        ),
        Provider(
          create: (context) =>
              WatchActiveWorkspaceUseCase(sessionRepository: context.read()),
        ),
        Provider(
          create: (context) => WatchAccountsUseCase(
            sessionRepository: context.read(),
            workspaceRepository: context.read(),
          ),
        ),
        Provider(
          create: (context) => RefreshAccountWorkspacesUseCase(
            sessionRepository: context.read(),
            workspaceRepository: context.read(),
          ),
        ),
        Provider(
          create: (context) => SignOutUseCase(
            sessionRepository: context.read(),
            workspaceRepository: context.read(),
          ),
        ),
      ],
      child: const AuthScope(child: MainApp()),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(
      sessionManager: context.read<SessionManager>(),
      signInFlowUseCase: context.read<SignInFlowUseCase>(),
      debugLogDiagnostics: BuildConfig().isDebug,
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: BuildConfig().appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
