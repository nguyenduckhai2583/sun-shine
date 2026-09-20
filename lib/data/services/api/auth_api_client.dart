import 'package:sun_shine/core.dart';

class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();

  @override
  String toString() => 'InvalidCredentialsException()';
}

class AuthApiClient extends BaseApiClient {
  Future<Result<SessionApiModel>> signIn(String email, String password) async {
    try {
      if (!email.contains('@') || password.isEmpty) {
        return const Result.error(InvalidCredentialsException());
      }
      return Result.ok(
        SessionApiModel(
          token: 'token_${email.hashCode}',
          user: UserApiModel(
            id: 'user_${email.split('@').first}',
            email: email,
          ),
        ),
      );
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> signOut() async {
    try {
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
