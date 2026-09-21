import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../config/build_config.dart';

abstract final class EncryptUtil {
  static String generateSha1Password(String input) =>
      _sha1(input, salt: BuildConfig().passwordSalt);

  static String generateMd5Password(String input) =>
      _md5(input, salt: BuildConfig().unlockedSalt);

  static String _sha1(String input, {String salt = ''}) =>
      sha1.convert(utf8.encode('$input$salt')).toString();

  static String _md5(String input, {String salt = ''}) =>
      md5.convert(utf8.encode('$input$salt')).toString();
}
