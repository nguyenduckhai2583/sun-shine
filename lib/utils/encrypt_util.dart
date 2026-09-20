import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../config/build_config.dart';

/// Client-side password hashing.
///
/// The server never sees a plaintext password: sign-in sends a salted SHA1
/// digest. The salts arrive through `--dart-define-from-file`.
abstract final class EncryptUtil {
  /// What the server is sent in place of the password.
  static String generateSha1Password(String input) =>
      _sha1(input, salt: BuildConfig().passwordSalt);

  /// Derived from the SHA1 digest at sign-in and kept on the session.
  ///
  /// With the user's passcode it produces the key that unlocks their E2E
  /// private key, which is why it outlives the password itself.
  static String generateMd5Password(String input) =>
      _md5(input, salt: BuildConfig().unlockedSalt);

  // The salt is appended, never prepended — employer's server checks the
  // digest of `input + salt`, so reversing this silently fails every sign-in.
  static String _sha1(String input, {String salt = ''}) =>
      sha1.convert(utf8.encode('$input$salt')).toString();

  static String _md5(String input, {String salt = ''}) =>
      md5.convert(utf8.encode('$input$salt')).toString();
}
