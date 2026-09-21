import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sun_shine/core.dart';

class FakeSessionRepository implements SessionRepository {
  final _sessions = BehaviorSubject<List<Session>>.seeded(const []);
  final _activeUserId = BehaviorSubject<String?>.seeded(null);

  List<Session> stored = const [];
  Object? restoreError;
  int restoreCount = 0;
  final List<String> removed = [];

  void dispose() {
    _sessions.close();
    _activeUserId.close();
  }

  /// Replaces every account with [session], or signs out when null.
  void emit(Session? session) {
    if (session == null) {
      _sessions.add(const []);
      _activeUserId.add(null);
      return;
    }
    emitAll([session], activeUserId: session.userId);
  }

  void emitAll(List<Session> sessions, {String? activeUserId}) {
    _sessions.add(List.unmodifiable(sessions));
    _activeUserId.add(activeUserId ?? sessions.firstOrNull?.userId);
  }

  @override
  Stream<Session?> get activeSession => Rx.combineLatest2(
    _sessions.stream,
    _activeUserId.stream,
    (sessions, userId) =>
        sessions.firstWhereOrNull((session) => session.userId == userId),
  ).distinct();

  @override
  Session? get currentSession => _sessions.value.firstWhereOrNull(
    (session) => session.userId == _activeUserId.value,
  );

  @override
  Stream<List<Session>> get sessions => _sessions.stream;

  @override
  List<Session> get allSessions => _sessions.value;

  @override
  Session? sessionOf(String userId) =>
      _sessions.value.firstWhereOrNull((session) => session.userId == userId);

  @override
  bool get isSignedIn => currentSession != null;

  @override
  Future<void> adoptSession(Session session) async {
    _upsert(session);
    _activeUserId.add(session.userId);
  }

  @override
  Future<void> assignWorkspace(String workspaceId) async {
    final session = currentSession;
    if (session == null) return;
    _upsert(session.copyWith(workspaceId: workspaceId));
  }

  @override
  Future<void> setActive(String userId) async {
    if (sessionOf(userId) == null) return;
    _activeUserId.add(userId);
  }

  @override
  Future<void> renewToken({
    required String token,
    String? refreshToken,
    int? expireAt,
    String? userId,
  }) async {
    final session = userId == null ? currentSession : sessionOf(userId);
    if (session == null) return;
    _upsert(
      session.copyWith(
        token: token,
        refreshToken: refreshToken ?? session.refreshToken,
        expireAt: expireAt ?? session.expireAt,
      ),
    );
  }

  @override
  Future<void> removeAccount(String userId) async {
    removed.add(userId);
    final remaining = [
      for (final session in _sessions.value)
        if (session.userId != userId) session,
    ];
    _sessions.add(List.unmodifiable(remaining));
    if (_activeUserId.value == userId) {
      _activeUserId.add(remaining.firstOrNull?.userId);
    }
  }

  @override
  Future<void> restore() async {
    restoreCount++;
    if (restoreError case final error?) throw error;
    emitAll(stored);
  }

  @override
  Future<void> signOutActive() async {
    final active = currentSession;
    if (active == null) return;
    await removeAccount(active.userId);
  }

  @override
  Future<void> signOutAll() async => emit(null);

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
}
