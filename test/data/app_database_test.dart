import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sun_shine/core.dart';

class _TempPathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  _TempPathProvider(this.root);

  final String root;

  @override
  Future<String?> getApplicationDocumentsPath() async => root;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory root;
  final realProvider = PathProviderPlatform.instance;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('sun_shine_app_db');
    PathProviderPlatform.instance = _TempPathProvider(root.path);
  });

  tearDown(() async {
    await AppDatabase.instance.close();
    PathProviderPlatform.instance = realProvider;
    if (root.existsSync()) root.deleteSync(recursive: true);
  });

  group('AppDatabase', () {
    test('starts closed', () {
      expect(AppDatabase.instance.isOpen, isFalse);
      expect(AppDatabase.instance.isar, isNull);
    });

    test('opening makes it available', () async {
      await AppDatabase.instance.open();

      expect(AppDatabase.instance.isOpen, isTrue);
    });

    test('opening twice hands back the same instance', () async {
      final first = await AppDatabase.instance.open();
      final second = await AppDatabase.instance.open();

      expect(identical(first, second), isTrue);
    });

    test('it lands under a version-stamped directory', () async {
      await AppDatabase.instance.open();

      expect(root.listSync().map((e) => e.path.split('/').last), [
        'sun_shine-v1',
      ]);
    });

    test('closing gives back a closed database', () async {
      await AppDatabase.instance.open();

      await AppDatabase.instance.close();

      expect(AppDatabase.instance.isOpen, isFalse);
    });

    test('a service given no database of its own uses the shared one', () async {
      await AppDatabase.instance.open();

      final service = AuthLocalService();
      addTearDown(service.dispose);

      expect(service.isPersistent, isTrue);
    });

    test('a service built while it is closed holds its data in memory', () {
      final service = AuthLocalService();
      addTearDown(service.dispose);

      expect(service.isPersistent, isFalse);
    });
  });
}
