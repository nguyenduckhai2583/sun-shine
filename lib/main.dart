import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BuildConfig().setupEnvironment();
  Di.observer = const DiLog();
  DiLog.enabled = BuildConfig().isDebug;
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => AuthApiClient()),
        Provider(
          create: (context) => AuthLocalService(),
          dispose: (context, service) => service.dispose(),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            apiClient: context.read(),
            localService: context.read(),
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
      authRepository: context.read<AuthRepository>(),
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
      routerConfig: _router,
    );
  }
}
