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
          userId: 'user_${email.split('@').first}',
          email: email,
          accessToken: 'token_${email.hashCode}',
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
