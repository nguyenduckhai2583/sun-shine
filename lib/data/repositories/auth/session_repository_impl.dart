import 'package:sun_shine/core.dart';

class SessionRepositoryImpl extends BaseRepo implements SessionRepository {
  SessionRepositoryImpl({required AuthLocalService localService})
    : _localService = localService;

  final AuthLocalService _localService;

  @override
  Stream<Session?> get activeSession => _localService.session;

  @override
  Session? get currentSession => _localService.currentSession;

  @override
  Stream<List<Session>> get sessions => _localService.sessions;

  @override
  List<Session> get allSessions => _localService.allSessions;

  @override
  Session? sessionOf(String userId) => _localService.sessionOf(userId);

  @override
  bool get isSignedIn => currentSession != null;

  @override
  Future<void> restore() => _localService.restore();

  @override
  Future<void> adoptSession(Session session) async {
    await _localService.save(session);
  }

  @override
  Future<void> assignWorkspace(String workspaceId) async {
    final session = currentSession;
    if (session == null) return;
    await _localService.save(session.copyWith(workspaceId: workspaceId));
  }

  @override
  Future<void> setActive(String userId) => _localService.setActive(userId);

  @override
  Future<void> renewToken({
    required String token,
    String? refreshToken,
    int? expireAt,
    String? userId,
  }) async {
    final session = userId == null ? currentSession : sessionOf(userId);
    if (session == null) return;
    await _localService.update(
      session.copyWith(
        token: token,
        refreshToken: refreshToken ?? session.refreshToken,
        expireAt: expireAt ?? session.expireAt,
      ),
    );
  }

  @override
  Future<void> removeAccount(String userId) => _localService.remove(userId);

  @override
  Future<void> signOutActive() async {
    final active = currentSession;
    if (active == null) return;
    await _localService.remove(active.userId);
  }

  @override
  Future<void> signOutAll() => _localService.clear();
}
