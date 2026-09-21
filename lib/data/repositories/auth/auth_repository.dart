import 'package:sun_shine/core.dart';

abstract class AuthRepository {
  Future<Result<Session>> signInRemote(AuthRequest request);

  Future<Result<User>> getMyProfileRemote();

  Future<Result<void>> signOutRemote();
}
