import 'package:sun_shine/core.dart';

abstract class SessionRepository {
  Stream<Session?> get activeSession;

  Session? get currentSession;

  Stream<List<Session>> get sessions;

  List<Session> get allSessions;

  Session? sessionOf(String userId);

  bool get isSignedIn;

  Future<void> restore();

  /// Upserts a freshly signed-in account and makes it active.
  Future<void> adoptSession(Session session);

  Future<void> assignWorkspace(String workspaceId);

  Future<void> setActive(String userId);

  /// Renews the active account's token, or [userId]'s when given.
  Future<void> renewToken({
    required String token,
    String? refreshToken,
    int? expireAt,
    String? userId,
  });

  Future<void> removeAccount(String userId);

  /// Signs out the active account and promotes the next one, if any.
  Future<void> signOutActive();

  Future<void> signOutAll();
}
