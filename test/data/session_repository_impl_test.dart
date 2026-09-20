import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('SessionRepositoryImpl', () {
    late AuthLocalService localService;
    late SessionRepositoryImpl repository;

    const khai = Session(
      userId: 'u1',
      token: 't1',
      user: User(id: 'u1', email: 'khai@sunshine.com'),
    );

    setUp(() {
      localService = AuthLocalService();
      repository = SessionRepositoryImpl(localService: localService);
      addTearDown(localService.dispose);
    });

    test('starts signed out', () {
      expect(repository.isSignedIn, isFalse);
      expect(repository.currentSession, isNull);
    });

    test('adopting a session makes it current', () async {
      await repository.adoptSession(khai);

      expect(repository.isSignedIn, isTrue);
      expect(repository.currentSession?.userId, 'u1');
    });

    test('currentSession is readable synchronously, for the redirect', () async {
      await repository.adoptSession(khai);

      // The router's redirect cannot await, so this must not be stream-only.
      expect(repository.currentSession, isNotNull);
    });

    test('activeSession emits on adopt and on sign-out', () {
      expect(
        repository.activeSession.map((s) => s?.userId),
        emitsInOrder([null, 'u1', null]),
      );

      repository.adoptSession(khai).then((_) => repository.signOut());
    });

    test('assignWorkspace updates the active session', () async {
      await repository.adoptSession(khai);

      await repository.assignWorkspace('w1');

      expect(repository.currentSession?.workspaceId, 'w1');
      expect(repository.currentSession?.needsWorkspace, isFalse);
    });

    test('assignWorkspace does nothing while signed out', () async {
      await repository.assignWorkspace('w1');

      expect(repository.currentSession, isNull);
    });

    test('renewToken replaces the token and keeps the rest', () async {
      await repository.adoptSession(
        khai.copyWith(refreshToken: 'r1', workspaceId: 'w1'),
      );

      await repository.renewToken(token: 't2');

      expect(repository.currentSession?.token, 't2');
      expect(repository.currentSession?.refreshToken, 'r1');
      expect(repository.currentSession?.workspaceId, 'w1');
    });

    test('signOut clears everything', () async {
      await repository.adoptSession(khai);

      await repository.signOut();

      expect(repository.isSignedIn, isFalse);
      expect(repository.currentSession, isNull);
    });
  });
}
