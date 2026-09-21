import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

import 'fakes/fake_auth_api_client.dart';

Future<SessionRepository> pumpApp(
  WidgetTester tester, {
  String? initialLocation,
  bool signedIn = true,
  FakeAuthApiClient? authApi,
}) async {
  BuildConfig().setupEnvironment();

  final authLocalService = AuthLocalService();
  final sessionRepository = SessionRepositoryImpl(
    localService: authLocalService,
  );
  final sessionManager = SessionManager(sessionRepository: sessionRepository);
  addTearDown(authLocalService.dispose);
  addTearDown(sessionManager.dispose);

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => AuthManager(
            baseUrl: 'https://test.invalid/',
            apiClient: authApi ?? FakeAuthApiClient(),
          ),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(client: FakeAuthApiClient()),
        ),
        Provider(create: (context) => authLocalService),
        Provider<SessionRepository>(create: (context) => sessionRepository),
        Provider(create: (context) => sessionManager),
      ],
      child: AuthScope(
        child: _TestApp(
          sessionManager: sessionManager,
          initialLocation: initialLocation ?? Routes.home,
        ),
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

Session fakeSession({
  String userId = 'u1',
  String email = 'khai@sunshine.com',
  String? workspaceId = 'w1',
}) {
  return Session(
    userId: userId,
    token: 'tok_$userId',
    workspaceId: workspaceId,
    user: User(id: userId, email: email),
  );
}

class _TestApp extends StatefulWidget {
  const _TestApp({required this.sessionManager, required this.initialLocation});

  final SessionManager sessionManager;
  final String initialLocation;

  @override
  State<_TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<_TestApp> {
  late final GoRouter _router = createRouter(
    sessionManager: widget.sessionManager,
    initialLocation: widget.initialLocation,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: _router,
  );
}
