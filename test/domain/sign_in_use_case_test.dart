import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../testing/fakes/fake_auth_api_client.dart';

void main() {
  group('SignInUseCase', () {
    late FakeAuthApiClient apiClient;
    late AuthManager authManager;
    late SignInUseCase useCase;

    setUpAll(() => BuildConfig().setupEnvironment());

    setUp(() {
      apiClient = FakeAuthApiClient();
      authManager = AuthManager(baseUrl: 'https://test.invalid/');
      useCase = SignInUseCase(
        authManager: authManager,
        authRepository: AuthRepositoryImpl(apiClient: apiClient),
      );
    });

    test('never sends the plaintext password', () async {
      await useCase.signIn(email: 'khai@sunshine.com', password: 'password');

      expect(apiClient.lastRequest?.email, 'khai@sunshine.com');
      expect(apiClient.lastRequest?.sha1Password, isNot('password'));
      expect(
        apiClient.lastRequest?.sha1Password,
        EncryptUtil.generateSha1Password('password'),
      );
    });

    test('derives the md5 unlock material from the salted digest', () async {
      await useCase.signIn(email: 'khai@sunshine.com', password: 'password');

      expect(
        authManager.pending?.md5Password,
        EncryptUtil.generateMd5Password(
          EncryptUtil.generateSha1Password('password'),
        ),
      );
    });

    test('stores the session as pending on success', () async {
      final result = await useCase.signIn(
        email: 'khai@sunshine.com',
        password: 'password',
      );

      expect((result as Ok<bool>).value, isFalse);
      expect(authManager.pending?.token, 'tok');
    });

    test(
      'reports a temporary token so the caller can route to the OTP step',
      () async {
        apiClient.signInResult = const Result.ok(
          SessionApiModel(
            token: 'tmp',
            isTmpToken: true,
            user: UserApiModel(id: 'u1', email: 'khai@sunshine.com'),
          ),
        );

        final result = await useCase.signIn(
          email: 'khai@sunshine.com',
          password: 'password',
        );

        expect((result as Ok<bool>).value, isTrue);
      },
    );

    test('leaves nothing pending on failure', () async {
      apiClient.signInResult = const Result.error(
        ApiException(
          error: ApiErrorEnum.server,
          serverMessage: 'Invalid credentials',
          statusCode: 401,
        ),
      );

      final result = await useCase.signIn(
        email: 'khai@sunshine.com',
        password: 'wrong',
      );

      expect(result, isA<Error<bool>>());
      expect(authManager.pending, isNull);
    });
  });

  group('FinalizeSessionUseCase', () {
    late AuthManager authManager;
    late AuthLocalService localService;
    late SessionRepository sessionRepository;
    late FinalizeSessionUseCase useCase;

    setUp(() {
      authManager = AuthManager(baseUrl: 'https://test.invalid/');
      localService = AuthLocalService();
      sessionRepository = SessionRepositoryImpl(localService: localService);
      useCase = FinalizeSessionUseCase(
        authManager: authManager,
        sessionRepository: sessionRepository,
      );
      addTearDown(localService.dispose);
    });

    test('fails when nothing is pending', () async {
      expect(await useCase.execute(), isA<Error<Session>>());
      expect(sessionRepository.isSignedIn, isFalse);
    });

    test('refuses a session that still owes a second factor', () async {
      authManager.setPending(
        const Session(userId: 'u1', token: 'tmp', isTmpToken: true),
      );

      expect(await useCase.execute(), isA<Error<Session>>());
      expect(sessionRepository.isSignedIn, isFalse);
    });

    test('adopts the pending session and ends the flow', () async {
      authManager
        ..beginAddAccount()
        ..setPending(const Session(userId: 'u1', token: 'tok'));

      final result = await useCase.execute();

      expect(result, isA<Ok<Session>>());
      expect(sessionRepository.currentSession?.userId, 'u1');
      expect(authManager.pending, isNull);
      expect(authManager.isAddingAccount, isFalse);
    });
  });
}
