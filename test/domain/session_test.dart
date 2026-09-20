import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('Session', () {
    const user = User(id: 'u1', email: 'khai@sunshine.com');

    test('is not authenticated while the token is temporary', () {
      const session = Session(
        userId: 'u1',
        token: 't',
        isTmpToken: true,
        user: user,
      );

      expect(session.isFullyAuthenticated, isFalse);
    });

    test('is authenticated with a real token', () {
      const session = Session(userId: 'u1', token: 't', user: user);

      expect(session.isFullyAuthenticated, isTrue);
    });

    test('needs a workspace until one is assigned', () {
      const session = Session(userId: 'u1', token: 't', user: user);

      expect(session.needsWorkspace, isTrue);
      expect(session.copyWith(workspaceId: 'w1').needsWorkspace, isFalse);
    });

    test('is compared by value, not identity', () {
      const a = Session(userId: 'u1', token: 't', user: user);
      const b = Session(userId: 'u1', token: 't', user: user);

      expect(a, b);
    });
  });
}
