import 'dart:io';

import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sun_shine/core.dart';

const _schemaVersion = 'v1';

const _defaultName = 'sun_shine';

const _schemas = [SessionEntitySchema, WorkspaceEntitySchema];

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Isar? _isar;

  Isar? get isar => _isar;

  bool get isOpen => _isar != null;

  Future<Isar> open({String name = _defaultName}) async {
    final existing = _isar;
    if (existing != null) return existing;

    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory('${documents.path}/$name-$_schemaVersion');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return _isar = await Isar.open(
      _schemas,
      directory: directory.path,
      name: name,
    );
  }

  Future<void> close() async {
    final isar = _isar;
    _isar = null;
    await isar?.close();
  }
}
