import 'package:rxdart/rxdart.dart';
import 'package:sun_shine/core.dart';

class FakeSessionRepository implements SessionRepository {
  final _subject = BehaviorSubject<Session?>.seeded(null);

  void emit(Session? session) => _subject.add(session);

  Session? stored;
  Object? restoreError;
  int restoreCount = 0;

  void dispose() => _subject.close();

  @override
  Stream<Session?> get activeSession => _subject.stream.distinct();

  @override
  Session? get currentSession => _subject.valueOrNull;

  @override
  Stream<List<Session>> get sessions =>
      activeSession.map((s) => s == null ? [] : [s]);

  @override
  bool get isSignedIn => currentSession != null;

  @override
  Future<void> adoptSession(Session session) async => emit(session);

  @override
  Future<void> assignWorkspace(String workspaceId) async {
    final session = currentSession;
    if (session != null) emit(session.copyWith(workspaceId: workspaceId));
  }

  @override
  Future<void> renewToken({
    required String token,
    String? refreshToken,
    int? expireAt,
  }) async {
    final session = currentSession;
    if (session != null) emit(session.copyWith(token: token));
  }

  @override
  Future<void> restore() async {
    restoreCount++;
    if (restoreError case final error?) throw error;
    emit(stored);
  }

  @override
  Future<void> signOut() async => emit(null);
}
