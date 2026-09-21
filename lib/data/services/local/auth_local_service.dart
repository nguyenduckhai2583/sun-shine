import 'package:isar_community/isar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sun_shine/core.dart';

class AuthLocalService extends BaseIsarService<SessionEntity> {
  AuthLocalService({super.isar});

  final _session = BehaviorSubject<Session?>.seeded(null);

  Stream<Session?> get session => _session.stream.distinct();

  Session? get currentSession => _session.value;

  Future<void> restore() async {
    final collection = this.collection;
    if (collection == null) return;

    final active = await collection
        .filter()
        .isActiveEqualTo(true)
        .findFirst();
    final row = active ?? await collection.where().findFirst();
    _session.add(row?.toDomain());
  }

  Future<void> save(Session session) async {
    if (_session.value == session) return;
    _session.add(session);

    await write((collection) async {
      final active = await collection
          .filter()
          .isActiveEqualTo(true)
          .findAll();
      final demoted = active
          .where((row) => row.accountUserId != session.userId)
          .toList();
      for (final row in demoted) {
        row.isActive = false;
      }
      await collection.putAll(demoted);
      await collection.putByAccountUserId(
        SessionEntity.fromDomain(session, isActive: true),
      );
    });
  }

  Future<void> clear() async {
    if (_session.value != null) _session.add(null);
    await clearCollection();
  }

  bool get isDisposed => _session.isClosed;

  @override
  void dispose() {
    _session.close();
    super.dispose();
  }
}
