import 'package:collection/collection.dart';
import 'package:isar_community/isar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sun_shine/core.dart';

class AuthLocalService extends BaseIsarService<SessionEntity> {
  AuthLocalService({super.isar});

  static const _equality = DeepCollectionEquality();

  final _sessions = BehaviorSubject<List<Session>>.seeded(const []);
  final _activeUserId = BehaviorSubject<String?>.seeded(null);

  Stream<List<Session>> get sessions =>
      _sessions.stream.distinct(_equality.equals);

  List<Session> get allSessions => _sessions.value;

  Stream<Session?> get session => Rx.combineLatest2(
    _sessions.stream,
    _activeUserId.stream,
    _find,
  ).distinct();

  Session? get currentSession => _find(_sessions.value, _activeUserId.value);

  Session? sessionOf(String userId) => _find(_sessions.value, userId);

  Future<void> restore() async {
    final collection = this.collection;
    if (collection == null) return;

    final rows = await collection.where().findAll();
    final active =
        rows.firstWhereOrNull((row) => row.isActive) ?? rows.firstOrNull;

    _sessions.add([for (final row in rows) row.toDomain()]);
    _activeUserId.add(active?.accountUserId);
  }

  /// Upserts [session] and makes it the active account.
  Future<void> save(Session session) async {
    final unchanged =
        _activeUserId.value == session.userId &&
        sessionOf(session.userId) == session;
    if (unchanged) return;

    _upsert(session);
    _activeUserId.add(session.userId);

    await write((collection) async {
      final demoted = await collection
          .filter()
          .isActiveEqualTo(true)
          .not()
          .accountUserIdEqualTo(session.userId)
          .findAll();
      for (final row in demoted) {
        row.isActive = false;
      }
      await collection.putAll(demoted);
      await collection.putByAccountUserId(
        SessionEntity.fromDomain(session, isActive: true),
      );
    });
  }

  /// Upserts [session] without touching which account is active.
  Future<void> update(Session session) async {
    if (sessionOf(session.userId) == session) return;
    _upsert(session);

    await write((collection) async {
      final existing = await collection
          .filter()
          .accountUserIdEqualTo(session.userId)
          .findFirst();
      await collection.putByAccountUserId(
        SessionEntity.fromDomain(
          session,
          isActive: existing?.isActive ?? _activeUserId.value == session.userId,
        ),
      );
    });
  }

  Future<void> setActive(String userId) async {
    if (_activeUserId.value == userId) return;
    if (sessionOf(userId) == null) return;
    _activeUserId.add(userId);

    await write((collection) async {
      final rows = await collection.where().findAll();
      final changed = <SessionEntity>[];
      for (final row in rows) {
        final shouldBeActive = row.accountUserId == userId;
        if (row.isActive == shouldBeActive) continue;
        row.isActive = shouldBeActive;
        changed.add(row);
      }
      await collection.putAll(changed);
    });
  }

  /// Drops one account, promoting the next one when the active account goes.
  Future<void> remove(String userId) async {
    final remaining = [
      for (final session in _sessions.value)
        if (session.userId != userId) session,
    ];
    if (remaining.length == _sessions.value.length) return;

    _sessions.add(remaining);
    if (_activeUserId.value == userId) {
      _activeUserId.add(remaining.firstOrNull?.userId);
    }
    final promoted = _activeUserId.value;

    await write((collection) async {
      final stale = await collection
          .filter()
          .accountUserIdEqualTo(userId)
          .idProperty()
          .findAll();
      await collection.deleteAll(stale);

      if (promoted == null) return;
      final next = await collection
          .filter()
          .accountUserIdEqualTo(promoted)
          .findFirst();
      if (next == null || next.isActive) return;
      next.isActive = true;
      await collection.put(next);
    });
  }

  Future<void> clear() async {
    if (_sessions.value.isNotEmpty) _sessions.add(const []);
    if (_activeUserId.value != null) _activeUserId.add(null);
    await clearCollection();
  }

  bool get isDisposed => _sessions.isClosed;

  @override
  void dispose() {
    _sessions.close();
    _activeUserId.close();
    super.dispose();
  }

  void _upsert(Session session) {
    final next = List<Session>.from(_sessions.value);
    final index = next.indexWhere((s) => s.userId == session.userId);
    if (index == -1) {
      next.add(session);
    } else {
      next[index] = session;
    }
    _sessions.add(List.unmodifiable(next));
  }

  static Session? _find(List<Session> sessions, String? userId) {
    if (userId == null) return null;
    return sessions.firstWhereOrNull((session) => session.userId == userId);
  }
}
