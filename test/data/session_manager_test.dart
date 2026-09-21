import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../testing/fakes/fake_session_repository.dart';

void main() {
  const khai = Session(
    userId: 'u1',
    token: 't1',
    user: User(id: 'u1', email: 'khai@sunshine.com'),
  );

  late FakeSessionRepository repository;
  late SessionManager manager;

  setUp(() {
    repository = FakeSessionRepository();
    manager = SessionManager(sessionRepository: repository);
    addTearDown(manager.dispose);
    addTearDown(repository.dispose);
  });

  group('SessionManager', () {
    test('has not restored anything yet', () {
      expect(manager.isRestored, isFalse);
    });

    test('initSession restores and says so', () async {
      repository.stored = [khai];

      await manager.initSession();

      expect(manager.isRestored, isTrue);
      expect(manager.currentSession, khai);
    });

    test('a store with nothing in it still finishes the boot', () async {
      await manager.initSession();

      expect(manager.isRestored, isTrue);
      expect(manager.currentSession, isNull);
    });

    test('a store that throws still finishes the boot', () async {
      repository.restoreError = StateError('corrupt row');

      await manager.initSession();

      expect(manager.isRestored, isTrue, reason: 'or the app sits on splash');
      expect(manager.currentSession, isNull);
    });

    test('booting twice only reads the store once', () async {
      await manager.initSession();
      await manager.initSession();

      expect(repository.restoreCount, 1);
    });

    test('listeners are told when the boot finishes', () {
      expect(manager.restored, emitsInOrder([false, true]));

      manager.initSession();
    });

    test('it passes the active session through', () async {
      expect(
        manager.activeSession.map((s) => s?.userId),
        emitsInOrder([null, 'u1']),
      );

      await repository.adoptSession(khai);
    });
  });
}
