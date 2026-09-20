import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../testing/fakes/fake_auth_api_client.dart';

void main() {
  group('AuthRepositoryImpl', () {
    late FakeAuthApiClient apiClient;
    late AuthRepositoryImpl repository;

    const request = AuthRequest(
      email: 'khai@sunshine.com',
      sha1Password: 'digest',
    );

    setUp(() {
      apiClient = FakeAuthApiClient();
      repository = AuthRepositoryImpl(signInClient: apiClient);
    });

    test('maps the API session onto the domain model', () async {
      apiClient.signInResult = const Result.ok(
        SessionApiModel(
          token: 'tok',
          refreshToken: 'refresh',
          expireAt: 123,
          user: UserApiModel(
            id: 'u1',
            email: 'khai@sunshine.com',
            fullName: 'Khai',
          ),
        ),
      );

      final result = await repository.signInRemote(request);

      final session = (result as Ok<Session>).value;
      expect(session.userId, 'u1');
      expect(session.token, 'tok');
      expect(session.refreshToken, 'refresh');
      expect(session.expireAt, 123);
      expect(session.user?.fullName, 'Khai');
    });

    test('passes the request through untouched', () async {
      await repository.signInRemote(request);

      expect(apiClient.lastRequest?.email, 'khai@sunshine.com');
      expect(apiClient.lastRequest?.sha1Password, 'digest');
    });

    test('a temporary token survives the mapping', () async {
      apiClient.signInResult = const Result.ok(
        SessionApiModel(
          token: 'tmp',
          isTmpToken: true,
          user: UserApiModel(id: 'u1', email: 'khai@sunshine.com'),
        ),
      );

      final result = await repository.signInRemote(request);

      expect((result as Ok<Session>).value.isTmpToken, isTrue);
    });

    test('defaults isTmpToken to false when the server omits it', () async {
      final result = await repository.signInRemote(request);

      expect((result as Ok<Session>).value.isTmpToken, isFalse);
    });

    test('passes a failure through as-is', () async {
      apiClient.signInResult = const Result.error(
        ApiException(
          error: ApiErrorEnum.server,
          serverMessage: 'Invalid credentials',
          statusCode: 401,
        ),
      );

      final result = await repository.signInRemote(request);

      expect(result, isA<Error<Session>>());
      final error = (result as Error<Session>).error as ApiException;
      expect(error.serverMessage, 'Invalid credentials');
    });

    test('maps the profile onto the domain user', () async {
      final result = await repository.getMyProfileRemote();

      expect((result as Ok<User>).value.email, 'khai@sunshine.com');
    });

    test('signOut reaches the API', () async {
      await repository.signOutRemote();

      expect(apiClient.signOutCount, 1);
    });
  });
}
