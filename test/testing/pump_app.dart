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

  late SessionRepository sessionRepository;

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
  Widget build(BuildContext context) => MaterialApp.router(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: _router,
  );
}
