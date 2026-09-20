import 'package:sun_shine/core.dart';

/// In-memory session state.
///
/// The interface is what the rest of the app codes against; only this class
/// knows the sessions live in memory. Swapping the backing store for Isar
/// changes nothing above it.
class SessionRepositoryImpl extends BaseRepo implements SessionRepository {
  SessionRepositoryImpl({required AuthLocalService localService})
    : _localService = localService;

  final AuthLocalService _localService;

  @override
  Stream<Session?> get activeSession => _localService.session;

  @override
  Session? get currentSession => _localService.currentSession;

  @override
  Stream<List<Session>> get sessions =>
      activeSession.map((session) => session == null ? [] : [session]);

  @override
  bool get isSignedIn => currentSession != null;

  @override
  Future<void> adoptSession(Session session) async {
    _localService.save(session);
  }

  @override
  Future<void> assignWorkspace(String workspaceId) async {
    final session = currentSession;
    if (session == null) return;
    _localService.save(session.copyWith(workspaceId: workspaceId));
  }

  @override
  Future<void> renewToken({
    required String token,
    String? refreshToken,
    int? expireAt,
  }) async {
    final session = currentSession;
    if (session == null) return;
    _localService.save(
      session.copyWith(
        token: token,
        refreshToken: refreshToken ?? session.refreshToken,
        expireAt: expireAt ?? session.expireAt,
      ),
    );
  }

  @override
  Future<void> signOut() async {
    _localService.clear();
  }
}
