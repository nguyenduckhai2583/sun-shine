import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('SessionEntity', () {
    const khai = Session(
      userId: 'u1',
      token: 't1',
      refreshToken: 'r1',
      expireAt: 1790000000,
      workspaceId: 'w1',
      md5Password: 'm1',
      encryptedPrivateKey: 'e1',
      localEncryptedPrivateKey: 'l1',
      user: User(
        id: 'u1',
        email: 'khai@sunshine.com',
        fullName: 'Khai',
        avatar: 'khai.png',
      ),
    );

    test('carries every field back out again', () {
      final restored = SessionEntity.fromDomain(khai, isActive: true).toDomain();

      expect(restored, khai);
    });

    test('files the row under the account it belongs to', () {
      final entity = SessionEntity.fromDomain(khai, isActive: true);

      expect(entity.accountUserId, 'u1');
    });

    test('remembers whether the row is the active one', () {
      expect(SessionEntity.fromDomain(khai, isActive: true).isActive, isTrue);
      expect(SessionEntity.fromDomain(khai, isActive: false).isActive, isFalse);
    });

    test('a session with no profile round trips as one with no profile', () {
      const bare = Session(userId: 'u2', token: 't2');

      final restored = SessionEntity.fromDomain(bare, isActive: false).toDomain();

      expect(restored, bare);
      expect(restored.user, isNull);
    });
  });
}
