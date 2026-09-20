import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'session.freezed.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    required String userId,
    required String token,
    String? refreshToken,
    int? expireAt,
    @Default(false) bool isTmpToken,
    String? workspaceId,
    User? user,

    /// The MD5 of the salted password, derived at sign-in.
    ///
    /// Combined with the user's passcode it produces the key that unlocks
    /// [encryptedPrivateKey]; the plaintext password is never kept.
    String? md5Password,

    /// The user's E2E private key as the server holds it — wrapped with a key
    /// derived from their credentials, so the server cannot read it.
    String? encryptedPrivateKey,

    /// The same private key re-wrapped with this device's key, so unlocking it
    /// again does not require the password.
    String? localEncryptedPrivateKey,
  }) = _Session;

  const Session._();

  /// A temporary token still needs a second factor — an auth code or a
  /// passcode — before the account is usable.
  bool get isFullyAuthenticated => !isTmpToken;

  bool get needsWorkspace => workspaceId == null;
}
