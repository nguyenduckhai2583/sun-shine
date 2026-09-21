import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../testing/fakes/fake_auth_local_service.dart';

void main() {
  group('SessionRepositoryImpl', () {
    late AuthLocalService localService;
    late SessionRepositoryImpl repository;

    const khai = Session(
      userId: 'u1',
      token: 't1',
      user: User(id: 'u1', email: 'khai@sunshine.com'),
    );
    const linh = Session(
      userId: 'u2',
      token: 't2',
      user: User(id: 'u2', email: 'linh@sunshine.com'),
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

    test(
      'currentSession is readable synchronously, for the redirect',
      () async {
        await repository.adoptSession(khai);

        expect(repository.currentSession, isNotNull);
      },
    );

    test('activeSession emits on adopt and on sign-out', () {
      expect(
        repository.activeSession.map((s) => s?.userId),
        emitsInOrder([null, 'u1', null]),
      );

      repository.adoptSession(khai).then((_) => repository.signOutAll());
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

    test('sessions lists every signed-in account', () async {
      await repository.adoptSession(khai);
      await repository.adoptSession(linh);

      expect(repository.allSessions.map((s) => s.userId), ['u1', 'u2']);
      expect(repository.currentSession?.userId, 'u2');
    });

    test('sessionOf reaches a background account', () async {
      await repository.adoptSession(khai);
      await repository.adoptSession(linh);

      expect(repository.sessionOf('u1')?.token, 't1');
      expect(repository.sessionOf('nobody'), isNull);
    });

    test('setActive changes which account is current', () async {
      await repository.adoptSession(khai);
      await repository.adoptSession(linh);

      await repository.setActive('u1');

      expect(repository.currentSession?.userId, 'u1');
      expect(repository.allSessions, hasLength(2));
    });

    test('renewToken can renew a background account', () async {
      await repository.adoptSession(khai);
      await repository.adoptSession(linh);

      await repository.renewToken(token: 't1-fresh', userId: 'u1');

      expect(repository.sessionOf('u1')?.token, 't1-fresh');
      expect(repository.currentSession?.userId, 'u2');
    });

    test('signOutActive promotes the next account', () async {
      await repository.adoptSession(khai);
      await repository.adoptSession(linh);

      await repository.signOutActive();

      expect(repository.isSignedIn, isTrue);
      expect(repository.currentSession?.userId, 'u1');
    });

    test('signOutActive on the last account signs out for good', () async {
      await repository.adoptSession(khai);

      await repository.signOutActive();

      expect(repository.isSignedIn, isFalse);
    });

    test('removeAccount drops a background account only', () async {
      await repository.adoptSession(khai);
      await repository.adoptSession(linh);

      await repository.removeAccount('u1');

      expect(repository.allSessions.map((s) => s.userId), ['u2']);
      expect(repository.currentSession?.userId, 'u2');
    });

    test('signOutAll clears everything', () async {
      await repository.adoptSession(khai);

      await repository.signOutAll();

      expect(repository.isSignedIn, isFalse);
      expect(repository.currentSession, isNull);
    });
  });

  group('SessionRepositoryImpl storage', () {
    const khai = Session(
      userId: 'u1',
      token: 't1',
      user: User(id: 'u1', email: 'khai@sunshine.com'),
    );

    test('adopting reports done only once the session is stored', () async {
      final gate = Completer<void>();
      final service = GatedAuthLocalService(gate: gate.future);
      addTearDown(service.dispose);
      final repository = SessionRepositoryImpl(localService: service);

      var done = false;
      unawaited(repository.adoptSession(khai).then((_) => done = true));
      await pumpEventQueue();
      expect(done, isFalse, reason: 'still waiting on storage');

      gate.complete();
      await pumpEventQueue();
      expect(done, isTrue);
    });

    test('signing out reports done only once storage is emptied', () async {
      final gate = Completer<void>();
      final service = GatedAuthLocalService(gate: gate.future);
      addTearDown(service.dispose);
      final repository = SessionRepositoryImpl(localService: service);

      var done = false;
      unawaited(repository.signOutAll().then((_) => done = true));
      await pumpEventQueue();
      expect(done, isFalse, reason: 'still waiting on storage');

      gate.complete();
      await pumpEventQueue();
      expect(done, isTrue);
    });
  });
}
