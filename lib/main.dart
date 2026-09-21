import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BuildConfig().setupEnvironment();
  Di.observer = const DiLog();
  DiLog.enabled = BuildConfig().isDebug;

  await AppDatabase.instance.open();

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) =>
              AuthManager(baseUrl: BuildConfig().env.baseApiUrl),
        ),
        Provider(
          create: (context) => AuthLocalService(),
          dispose: (context, service) => service.dispose(),
        ),
        Provider<SessionRepository>(
          create: (context) =>
              SessionRepositoryImpl(localService: context.read()),
        ),
        Provider(
          create: (context) => SessionManager(sessionRepository: context.read()),
          dispose: (context, manager) => manager.dispose(),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            client: AuthApiClient(
              AppDio.create(
                baseUrl: BuildConfig().env.baseApiUrl,
                sessionRepository: context.read(),
              ),
            ),
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
