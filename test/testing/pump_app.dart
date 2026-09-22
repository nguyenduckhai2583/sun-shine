import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

import 'fakes/fake_auth_api_client.dart';
import 'fakes/fake_token_refresh_api_client.dart';
import 'fakes/fake_workspace_api_client.dart';

Future<SessionRepository> pumpApp(
  WidgetTester tester, {
  String? initialLocation,
  bool signedIn = true,
  FakeAuthApiClient? authApi,
  WorkspaceApiClient? workspaceApi,
  FakeTokenRefreshApiClient? tokenRefreshApi,
  StubHttpAdapter? httpAdapter,
}) async {
  BuildConfig().setupEnvironment();

  final authLocalService = AuthLocalService();
  final workspaceLocalService = WorkspaceLocalService();
  final sessionRepository = SessionRepositoryImpl(
    localService: authLocalService,
  );
  final workspaceRepository = WorkspaceRepositoryImpl(
    apiClient: workspaceApi ?? FakeWorkspaceApiClient(),
    localService: workspaceLocalService,
  );
  // The real authed client, so tests see the same headers production sends.
  final dio = AppDio.create(
    baseUrl: 'https://test.invalid',
    sessionRepository: sessionRepository,
  )..httpClientAdapter = httpAdapter ?? StubHttpAdapter();
  final sessionManager = SessionManager(sessionRepository: sessionRepository);
  final authManager = AuthManager(
    baseUrl: 'https://test.invalid/',
    apiClient: authApi ?? FakeAuthApiClient(),
  );
  final signInFlowUseCase = SignInFlowUseCase(authManager: authManager);
  final switchAccountUseCase = SwitchAccountUseCase(
    sessionRepository: sessionRepository,
    workspaceRepository: workspaceRepository,
    tokenRefreshApiClient: tokenRefreshApi ?? FakeTokenRefreshApiClient(),
  );

  addTearDown(authLocalService.dispose);
  addTearDown(workspaceLocalService.dispose);
  addTearDown(sessionManager.dispose);
  addTearDown(authManager.dispose);

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider<Dio>(create: (context) => dio),
        Provider(create: (context) => authManager),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(client: FakeAuthApiClient()),
        ),
        Provider(create: (context) => authLocalService),
        Provider(create: (context) => workspaceLocalService),
        Provider<SessionRepository>(create: (context) => sessionRepository),
        Provider<WorkspaceRepository>(create: (context) => workspaceRepository),
        Provider(create: (context) => sessionManager),
        Provider(create: (context) => signInFlowUseCase),
        Provider(create: (context) => switchAccountUseCase),
        Provider(
          create: (context) => SelectWorkspaceUseCase(
            sessionRepository: sessionRepository,
            switchAccountUseCase: switchAccountUseCase,
          ),
        ),
        Provider(
          create: (context) =>
              WatchActiveWorkspaceUseCase(sessionRepository: sessionRepository),
        ),
        Provider(
          create: (context) => WatchAccountsUseCase(
            sessionRepository: sessionRepository,
            workspaceRepository: workspaceRepository,
          ),
        ),
        Provider(
          create: (context) => RefreshAccountWorkspacesUseCase(
            sessionRepository: sessionRepository,
            workspaceRepository: workspaceRepository,
          ),
        ),
        Provider(
          create: (context) => SignOutUseCase(
            sessionRepository: sessionRepository,
            workspaceRepository: workspaceRepository,
          ),
        ),
      ],
      child: AuthScope(
        child: _TestApp(
          sessionManager: sessionManager,
          signInFlowUseCase: signInFlowUseCase,
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
  String? refreshToken,
  int? expireAt,
}) {
  return Session(
    userId: userId,
    token: 'tok_$userId',
    refreshToken: refreshToken,
    expireAt: expireAt,
    workspaceId: workspaceId,
    user: User(id: userId, email: email),
  );
}

class _TestApp extends StatefulWidget {
  const _TestApp({
    required this.sessionManager,
    required this.signInFlowUseCase,
    required this.initialLocation,
  });

  final SessionManager sessionManager;
  final SignInFlowUseCase signInFlowUseCase;
  final String initialLocation;

  @override
  State<_TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<_TestApp> {
  late final GoRouter _router = createRouter(
    sessionManager: widget.sessionManager,
    signInFlowUseCase: widget.signInFlowUseCase,
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

/// Serves canned bodies to whatever the session scope builds on the shared
/// [Dio], so widget tests exercise the real client and repository without a
/// network.
class StubHttpAdapter implements HttpClientAdapter {
  StubHttpAdapter({Map<String, String>? bodies, this.status = 200})
    : bodies = bodies ?? {...defaultBodies};

  static const channelsBody =
      '[{"id":"general","name":"general"},'
      '{"id":"engineering","name":"engineering","isPrivate":true},'
      '{"id":"design","name":"design","isEncrypted":true},'
      '{"id":"random","name":"random"}]';

  static const defaultBodies = {'/chat-services/channels': channelsBody};

  final Map<String, String> bodies;
  int status;

  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final body = bodies[options.uri.path] ?? '{}';
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
