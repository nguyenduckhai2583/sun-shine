import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('UserApiModel', () {
    test('reads the avatar url out of the file object the api sends', () {
      final model = UserApiModel.fromJson(const {
        'id': '019da389-cdb6-7e43-a6a0-87da69de7d7a',
        'email': 'khai@hodfords.com',
        'avatar': {
          'name': 'Screenshot.png',
          'path': 'public/images/…/530_910.jpg',
          'fileType': 'IMAGE',
          'size': 72069,
          'signedUrl': 'https://cdn.invalid/avatar-530_910.jpg',
        },
      });

      expect(model.id, '019da389-cdb6-7e43-a6a0-87da69de7d7a');
      expect(model.email, 'khai@hodfords.com');
      expect(model.avatar, 'https://cdn.invalid/avatar-530_910.jpg');
    });

    test('builds a display name the way the api splits it', () {
      final model = UserApiModel.fromJson(const {
        'id': 'u1',
        'email': 'khai@hodfords.com',
        'firstName': 'Khai',
        'lastName': 'Nguyen',
      });

      expect(model.displayName, 'Nguyen Khai');
    });

    test('falls back to whichever half of the name it was given', () {
      const onlyFirst = UserApiModel(
        id: 'u1',
        email: 'a@b.c',
        firstName: 'Khai',
      );
      const onlyLast = UserApiModel(
        id: 'u1',
        email: 'a@b.c',
        lastName: 'Nguyen',
      );
      const neither = UserApiModel(id: 'u1', email: 'a@b.c');

      expect(onlyFirst.displayName, 'Khai');
      expect(onlyLast.displayName, 'Nguyen');
      expect(neither.displayName, isNull);
    });

    test('accepts a user with no avatar', () {
      final model = UserApiModel.fromJson(const {
        'id': 'u1',
        'email': 'khai@hodfords.com',
        'avatar': null,
      });

      expect(model.avatar, isNull);
    });
  });
}
