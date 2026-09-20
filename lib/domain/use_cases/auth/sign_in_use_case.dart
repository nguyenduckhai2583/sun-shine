import 'package:sun_shine/core.dart';

/// Password sign-in.
///
/// Returns whether the server issued a *temporary* token — true means the user
/// still owes a second factor, so the caller routes to the auth-code or
/// passcode step instead of finalizing.
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
        // The MD5 of the salted digest is what later unlocks the E2E private
        // key, together with the user's passcode. This is the only moment it
        // can be derived — the password is gone once this method returns.
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
