import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:sun_shine/core.dart';

void main() {
  SessionEntity row(String userId) =>
      SessionEntity(accountUserId: userId, isActive: false, token: 't-$userId');

  group('BaseIsarService without a database', () {
    late AuthLocalService service;

    setUp(() {
      service = AuthLocalService();
      addTearDown(service.dispose);
    });

    test('says it does not persist', () {
      expect(service.isPersistent, isFalse);
    });

    test('reads come back empty instead of throwing', () async {
      expect(await service.getAll(), isEmpty);
      expect(await service.getById(1), isNull);
    });

    test('writes are quietly dropped', () async {
      await service.put(row('u1'));
      await service.clearCollection();

      expect(await service.getAll(), isEmpty);
    });

    test('watching yields an empty collection', () {
      expect(service.watchAll(), emits(isEmpty));
    });
  });

  group('BaseIsarService with a database', () {
    late Directory directory;
    late Isar isar;
    late AuthLocalService service;

    setUpAll(() => Isar.initializeIsarCore(download: true));

    setUp(() async {
      directory = await Directory.systemTemp.createTemp('sun_shine_base');
      isar = await Isar.open([SessionEntitySchema], directory: directory.path);
      service = AuthLocalService(isar: isar);
      addTearDown(service.dispose);
    });

    tearDown(() async {
      if (isar.isOpen) await isar.close(deleteFromDisk: true);
      if (directory.existsSync()) directory.deleteSync(recursive: true);
    });

    test('says it persists', () {
      expect(service.isPersistent, isTrue);
    });

    test('what is put can be read back', () async {
      await service.put(row('u1'));

      final all = await service.getAll();
      expect(all.map((e) => e.accountUserId), ['u1']);
    });

    test('putAll stores every row', () async {
      await service.putAll([row('u1'), row('u2')]);

      expect(await service.getAll(), hasLength(2));
    });

    test('getById finds the row it was given back', () async {
      await service.put(row('u1'));
      final stored = (await service.getAll()).single;

      expect((await service.getById(stored.id))?.accountUserId, 'u1');
    });

    test('deleteById removes just that row', () async {
      await service.putAll([row('u1'), row('u2')]);
      final first = (await service.getAll()).first;

      await service.deleteById(first.id);

      expect(await service.getAll(), hasLength(1));
    });

    test('clearCollection empties it', () async {
      await service.putAll([row('u1'), row('u2')]);

      await service.clearCollection();

      expect(await service.getAll(), isEmpty);
    });

    test('watching reports the rows, then reports a change', () {
      expect(
        service.watchAll().map((rows) => rows.length),
        emitsInOrder([0, 1]),
      );

      service.put(row('u1'));
    });
  });
}
