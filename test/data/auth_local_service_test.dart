import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:sun_shine/core.dart';

void main() {
  const khai = Session(
    userId: 'u1',
    token: 't1',
    refreshToken: 'r1',
    workspaceId: 'w1',
    md5Password: 'm1',
    user: User(id: 'u1', email: 'khai@sunshine.com'),
  );
  const linh = Session(
    userId: 'u2',
    token: 't2',
    user: User(id: 'u2', email: 'linh@sunshine.com'),
  );

  group('AuthLocalService without a database', () {
    late AuthLocalService service;

    setUp(() {
      service = AuthLocalService();
      addTearDown(service.dispose);
    });

    test('starts with no session', () {
      expect(service.currentSession, isNull);
    });

    test('a saved session is readable synchronously, for the redirect', () async {
      await service.save(khai);

      expect(service.currentSession, khai);
    });

    test('a saved session reaches listeners', () {
      expect(service.session.map((s) => s?.userId), emitsInOrder([null, 'u1']));

      service.save(khai);
    });

    test('saving the same session twice does not re-notify', () {
      expect(service.session.map((s) => s?.token), emitsInOrder([null, 't1']));

      service.save(khai);
      service.save(khai);
    });

    test('clearing drops the session', () async {
      await service.save(khai);

      await service.clear();

      expect(service.currentSession, isNull);
    });

    test('restore is a no-op, so the session in hand survives it', () async {
      await service.save(khai);

      await service.restore();

      expect(service.currentSession, khai);
    });
  });

  group('AuthLocalService with a database', () {
    late Directory directory;
    late Isar isar;
    late AuthLocalService service;

    setUpAll(() => Isar.initializeIsarCore(download: true));

    setUp(() async {
      directory = await Directory.systemTemp.createTemp('sun_shine_session');
      isar = await Isar.open([SessionEntitySchema], directory: directory.path);
      service = AuthLocalService(isar: isar);
      addTearDown(service.dispose);
    });

    tearDown(() async {
      if (isar.isOpen) await isar.close(deleteFromDisk: true);
      if (directory.existsSync()) directory.deleteSync(recursive: true);
    });

    test('restores nothing on a fresh install', () async {
      await service.restore();

      expect(service.currentSession, isNull);
    });

    test('the session outlives the process, whole', () async {
      await service.save(khai);
      await isar.close();

      isar = await Isar.open([SessionEntitySchema], directory: directory.path);
      final next = AuthLocalService(isar: isar);
      addTearDown(next.dispose);
      await next.restore();

      expect(next.currentSession, khai);
    });

    test('signing in again as the same account replaces its row', () async {
      await service.save(khai);
      await service.save(khai.copyWith(token: 't1-renewed'));

      expect(await isar.sessionEntitys.count(), 1);
      expect(service.currentSession?.token, 't1-renewed');
    });

    test('a newly saved account becomes the active one', () async {
      await service.save(khai);
      await service.save(linh);
      await service.restore();

      expect(service.currentSession?.userId, 'u2');
    });

    test('only ever one row is active', () async {
      await service.save(khai);
      await service.save(linh);

      final active = await isar.sessionEntitys
          .filter()
          .isActiveEqualTo(true)
          .findAll();
      expect(active, hasLength(1));
    });

    test('keeps the other account on the shelf, not deleted', () async {
      await service.save(khai);
      await service.save(linh);

      expect(await isar.sessionEntitys.count(), 2);
    });

    test('clearing empties the database too', () async {
      await service.save(khai);
      await service.save(linh);

      await service.clear();

      expect(service.currentSession, isNull);
      expect(await isar.sessionEntitys.count(), 0);
    });

    test('a cleared store has nothing to restore', () async {
      await service.save(khai);
      await service.clear();
      await service.restore();

      expect(service.currentSession, isNull);
    });
  });
}
