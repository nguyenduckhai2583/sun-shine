import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'config/build_config.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/services/api/auth_api_client.dart';
import 'routing/router.dart';
import 'ui/auth/widgets/auth_scope.dart';

void main() {
  BuildConfig().setupEnvironment();
  runApp(const SunShineApp());
}

/// Two nested scopes:
///
/// ```
/// SunShineApp        app scope      AuthApiClient, AuthRepository
/// └── AuthScope      session scope  Student/Teacher clients + repositories
///     └── _SunShineRouter           MaterialApp.router
/// ```
///
/// What a *user* owns goes in the session scope, so signing out disposes it.
/// What the *app* owns — the object that knows whether anyone is signed in —
/// has to sit above that, or it would tear itself down.
class SunShineApp extends StatelessWidget {
  const SunShineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Registered by their ABSTRACT type: this is the only place in the
        // app that names `Fake…`. Point it at a Dio-backed client and no
        // other file changes.
        Provider<AuthApiClient>(create: (context) => FakeAuthApiClient()),

        // A ChangeNotifierProvider because AuthScope and the app bar listen
        // to it. It reads the client declared above it — order matters
        // inside a MultiProvider.
        ChangeNotifierProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(apiClient: context.read()),
        ),
      ],
      child: const AuthScope(child: _SunShineRouter()),
    );
  }
}

class _SunShineRouter extends StatefulWidget {
  const _SunShineRouter();

  @override
  State<_SunShineRouter> createState() => _SunShineRouterState();
}

class _SunShineRouterState extends State<_SunShineRouter> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // `read` is legal in initState — it resolves once and never subscribes.
    //
    // This runs again on every session change, because AuthScope's key flips
    // and remounts this widget. A signed-out user's router is therefore never
    // handed to the next one.
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      routerConfig: _router,
    );
  }
}
