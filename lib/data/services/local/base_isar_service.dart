import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:sun_shine/core.dart';

abstract class BaseIsarService<T> extends BaseLocalService {
  BaseIsarService({Isar? isar}) : _isar = isar ?? AppDatabase.instance.isar;

  final Isar? _isar;

  @protected
  Isar? get isar => _isar;

  bool get isPersistent => _isar != null;

  @protected
  IsarCollection<T>? get collection => _isar?.collection<T>();

  Future<List<T>> getAll() async =>
      await collection?.where().findAll() ?? const [];

  Future<T?> getById(Id id) async => collection?.get(id);

  Future<void> put(T object) => write((collection) => collection.put(object));

  Future<void> putAll(List<T> objects) =>
      write((collection) => collection.putAll(objects));

  Future<void> deleteById(Id id) =>
      write((collection) => collection.delete(id));

  Future<void> clearCollection() => write((collection) => collection.clear());

  Stream<List<T>> watchAll() {
    final collection = this.collection;
    if (collection == null) return Stream.value(const []);
    return collection
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => getAll());
  }

  @protected
  Future<void> write(
    Future<void> Function(IsarCollection<T> collection) action,
  ) async {
    final isar = _isar;
    final collection = this.collection;
    if (isar == null || collection == null) return;
    await isar.writeTxn(() => action(collection));
  }
}
