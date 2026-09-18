import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

/// Boots the real app tree: auth scope, session scope, router.
///
/// Signs in by default so tests that care about the authenticated app do not
/// have to walk the sign-in form first.
Future<AuthRepository> pumpApp(
  WidgetTester tester, {
  String? initialLocation,
  bool signedIn = true,
}) async {
  late AuthRepository authRepository;

  await tester.pumpWidget(
    MultiProvider(
      providers: authProviders,
      child: Builder(
        builder: (context) {
          authRepository = context.read<AuthRepository>();
          return AuthScope(
            child: _TestApp(
              authRepository: authRepository,
              initialLocation: initialLocation ?? Routes.home,
            ),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();

  if (signedIn) {
    await authRepository.signIn('khai@sunshine.com', 'password');
    await tester.pumpAndSettle();
  }

  return authRepository;
}

class _TestApp extends StatefulWidget {
  const _TestApp({required this.authRepository, required this.initialLocation});

  final AuthRepository authRepository;
  final String initialLocation;

  @override
  State<_TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<_TestApp> {
  late final GoRouter _router = createRouter(
    authRepository: widget.authRepository,
    initialLocation: widget.initialLocation,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      MaterialApp.router(routerConfig: _router);
}
