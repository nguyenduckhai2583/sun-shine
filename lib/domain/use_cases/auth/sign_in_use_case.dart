import 'package:sun_shine/core.dart';

class SignInUseCase {
  SignInUseCase({
    required AuthManager authManager,
    required AuthRepository authRepository,
  }) : _authManager = authManager,
       _authRepository = authRepository;

  final AuthManager _authManager;
  final AuthRepository _authRepository;

  Future<Result<bool>> signIn({
    required String email,
    required String password,
  }) async {
    final sha1Password = EncryptUtil.generateSha1Password(password);
    final result = await _authRepository.signInRemote(
      AuthRequest(email: email, sha1Password: sha1Password),
    );

    return switch (result) {
      Ok(value: final session) => () {
        _authManager.setPending(
          session.copyWith(
            md5Password: EncryptUtil.generateMd5Password(sha1Password),
          ),
        );
        return Result<bool>.ok(session.isTmpToken);
      }(),
      Error(:final error) => Result<bool>.error(error),
    };
  }
}
