import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

import 'fakes/fake_auth_api_client.dart';

/// Boots the real app tree: auth scope, session scope, router.
///
/// The API client is faked, so nothing here touches the network. Signs in by
/// default, so tests that care about the authenticated app do not have to walk
/// the sign-in form first.
Future<SessionRepository> pumpApp(
  WidgetTester tester, {
  String? initialLocation,
  bool signedIn = true,
}) async {
  // Sign-in hashes the password, which reads the salts off BuildConfig.
  BuildConfig().setupEnvironment();

  late SessionRepository sessionRepository;

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        // The sign-in screen builds use cases that need it; its own client is
        // never called here because the repository below is faked.
        Provider(
          create: (context) => AuthManager(baseUrl: 'https://test.invalid/'),
        ),
        Provider<AuthRepository>(
          create: (context) =>
              AuthRepositoryImpl(apiClient: FakeAuthApiClient()),
        ),
        Provider(
          create: (context) => AuthLocalService(),
          dispose: (context, service) => service.dispose(),
        ),
        Provider<SessionRepository>(
          create: (context) =>
              SessionRepositoryImpl(localService: context.read()),
        ),
      ],
      child: Builder(
        builder: (context) {
          sessionRepository = context.read<SessionRepository>();
          return AuthScope(
            child: _TestApp(
              sessionRepository: sessionRepository,
              initialLocation: initialLocation ?? Routes.home,
            ),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();

  if (signedIn) {
    await sessionRepository.adoptSession(fakeSession());
    await tester.pumpAndSettle();
  }

  return sessionRepository;
}

/// A signed-in account, as the fake API would hand one back.
Session fakeSession({
  String userId = 'u1',
  String email = 'khai@sunshine.com',
}) {
  return Session(
    userId: userId,
    token: 'tok_$userId',
    user: User(id: userId, email: email),
  );
}

class _TestApp extends StatefulWidget {
  const _TestApp({
    required this.sessionRepository,
    required this.initialLocation,
  });

  final SessionRepository sessionRepository;
  final String initialLocation;

  @override
  State<_TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<_TestApp> {
  late final GoRouter _router = createRouter(
    sessionRepository: widget.sessionRepository,
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
