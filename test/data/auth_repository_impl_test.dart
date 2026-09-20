import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('AuthRepositoryImpl', () {
    late AuthLocalService localService;
    late AuthRepositoryImpl repository;

    setUp(() {
      localService = AuthLocalService();
      repository = AuthRepositoryImpl(
        apiClient: AuthApiClient(),
        localService: localService,
      );
      addTearDown(localService.dispose);
    });

    test('starts signed out', () {
      expect(repository.isSignedIn, isFalse);
      expect(repository.currentSession, isNull);
    });

    test('signIn stores the session', () async {
      final result = await repository.signIn('khai@sunshine.com', 'password');

      expect(result, isA<Ok<Session>>());
      expect(repository.isSignedIn, isTrue);
      expect(repository.currentSession?.email, 'khai@sunshine.com');
    });

    test('rejects invalid credentials', () async {
      final result = await repository.signIn('not-an-email', 'password');

      expect(result, isA<Error<Session>>());
      expect(
        (result as Error<Session>).error,
        isA<InvalidCredentialsException>(),
      );
      expect(repository.isSignedIn, isFalse);
    });

    test('rejects an empty password', () async {
      final result = await repository.signIn('khai@sunshine.com', '');

      expect(result, isA<Error<Session>>());
      expect(repository.isSignedIn, isFalse);
    });

    test('signOut clears the session', () async {
      await repository.signIn('khai@sunshine.com', 'password');
      await repository.signOut();

      expect(repository.isSignedIn, isFalse);
      expect(repository.currentSession, isNull);
    });

    test('the session stream emits sign-in then sign-out', () async {
      expect(
        repository.session,
        emitsInOrder([
          null,
          isA<Session>().having((s) => s.email, 'email', 'khai@sunshine.com'),
          null,
        ]),
      );

      await repository.signIn('khai@sunshine.com', 'password');
      await repository.signOut();
    });

    test('different users get different ids', () async {
      await repository.signIn('a@sunshine.com', 'password');
      final first = repository.currentSession!.userId;
      await repository.signOut();
      await repository.signIn('b@sunshine.com', 'password');

      expect(repository.currentSession!.userId, isNot(first));
    });
  });
}
