import 'package:sun_shine/core.dart';

abstract class AuthRepository {
  Stream<Session?> get session;

  Session? get currentSession;

  bool get isSignedIn;

  Future<Result<Session>> signIn(String email, String password);

  Future<Result<void>> signOut();
}
