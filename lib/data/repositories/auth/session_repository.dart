import 'package:sun_shine/core.dart';

abstract class SessionRepository {
  Stream<Session?> get activeSession;

  Session? get currentSession;

  Stream<List<Session>> get sessions;

  bool get isSignedIn;

  Future<void> adoptSession(Session session);

  Future<void> assignWorkspace(String workspaceId);

  Future<void> renewToken({
    required String token,
    String? refreshToken,
    int? expireAt,
  });

  Future<void> signOut();
}
