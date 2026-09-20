import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('EncryptUtil', () {
    setUpAll(() => BuildConfig().setupEnvironment());

    test('sha1 hashing is deterministic', () {
      expect(
        EncryptUtil.generateSha1Password('password'),
        EncryptUtil.generateSha1Password('password'),
      );
    });

    test('different passwords hash differently', () {
      expect(
        EncryptUtil.generateSha1Password('password'),
        isNot(EncryptUtil.generateSha1Password('password1')),
      );
    });

    test('it never returns the plaintext', () {
      expect(EncryptUtil.generateSha1Password('password'), isNot('password'));
    });

    test('sha1 output is a 40-character hex digest', () {
      final digest = EncryptUtil.generateSha1Password('password');

      expect(digest, hasLength(40));
      expect(digest, matches(RegExp(r'^[0-9a-f]+$')));
    });

    test('md5 hashing is deterministic', () {
      expect(
        EncryptUtil.generateMd5Password('abc'),
        EncryptUtil.generateMd5Password('abc'),
      );
    });

    test('md5 output is a 32-character hex digest', () {
      expect(EncryptUtil.generateMd5Password('abc'), hasLength(32));
    });
  });
}
