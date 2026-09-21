import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../testing/fakes/fake_auth_api_client.dart';

void main() {
  group('AuthManager', () {
    late AuthManager manager;

    const session = Session(
      userId: 'u1',
      token: 'tok',
      user: User(id: 'u1', email: 'khai@sunshine.com'),
    );

    setUp(() {
      manager = AuthManager(baseUrl: 'https://example.test/');
    });

    test('starts with nothing pending and not adding an account', () {
      expect(manager.pending, isNull);
      expect(manager.isAddingAccount, isFalse);
    });

    test('setPending stores the session and sets the auth header', () {
      manager.setPending(session);

      expect(manager.pending, session);
      expect(manager.dio.options.headers['Authorization'], 'Bearer tok');
    });

    test('clearPending drops the session but keeps the flow open', () {
      manager
        ..beginAddAccount()
        ..setPending(session)
        ..clearPending();

      expect(manager.pending, isNull);
      expect(manager.dio.options.headers['Authorization'], isNull);
      expect(manager.isAddingAccount, isTrue);
    });

    test('reset ends the flow', () {
      manager
        ..beginAddAccount()
        ..setPending(session)
        ..reset();

      expect(manager.pending, isNull);
      expect(manager.isAddingAccount, isFalse);
    });

    test('its Dio is its own, never shared', () {
      final other = AuthManager(baseUrl: 'https://example.test/');

      expect(identical(manager.dio, other.dio), isFalse);
    });

    test('carries the host it was given', () {
      expect(manager.dio.options.baseUrl, 'https://example.test/');
    });

    test('its repository speaks through its own client', () async {
      final apiClient = FakeAuthApiClient();
      final scoped = AuthManager(
        baseUrl: 'https://example.test/',
        apiClient: apiClient,
      );

      await scoped.authRepository.signInRemote(
        const AuthRequest(email: 'khai@sunshine.com', sha1Password: 'digest'),
      );

      expect(apiClient.lastRequest?.email, 'khai@sunshine.com');
    });

    test('hands out the same repository every time', () {
      expect(identical(manager.authRepository, manager.authRepository), isTrue);
    });
  });
}
