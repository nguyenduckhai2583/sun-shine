import 'package:sun_shine/core.dart';

/// Who is signed in, and which of several accounts is active.
///
/// Deliberately knows nothing about navigation. Employer's `SessionManager`
/// called `Get.offAllNamed` from here; under `go_router` the router watches
/// [activeSession] and decides where the user belongs.
abstract class SessionRepository {
  /// Emits on every change of the active account, including sign-out (null).
  Stream<Session?> get activeSession;

  /// The active account right now, so the router's redirect stays synchronous.
  Session? get currentSession;

  /// Every account the app holds, for the account switcher.
  Stream<List<Session>> get sessions;

  bool get isSignedIn;

  /// Takes a finished sign-in and makes it the active account.
  Future<void> adoptSession(Session session);

  Future<void> assignWorkspace(String workspaceId);

  Future<void> signOut();
}
