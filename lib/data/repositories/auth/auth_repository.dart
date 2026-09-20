import 'package:sun_shine/core.dart';

/// The HTTP facade for authentication.
///
/// It holds no session state: which account is signed in, and which of several
/// is active, belongs to `SessionRepository`.
abstract class AuthRepository {
  Future<Result<Session>> signInRemote(AuthRequest request);

  Future<Result<User>> getMyProfileRemote();

  Future<Result<void>> signOutRemote();
}
