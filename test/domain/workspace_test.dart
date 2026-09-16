import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('Workspace', () {
    test('initial is the uppercased first letter', () {
      expect(const Workspace(id: 'a', name: 'sun shine').initial, 'S');
    });
    test('initial falls back to ? for an empty name', () {
      expect(const Workspace(id: 'a', name: '').initial, '?');
    });
    test('unreadCount defaults to zero', () {
      expect(const Workspace(id: 'a', name: 'A').unreadCount, 0);
    });
    test('is compared by value, not identity', () {
      expect(
        const Workspace(id: 'a', name: 'A'),
        const Workspace(id: 'a', name: 'A'),
      );
    });
    test('copyWith leaves untouched fields alone', () {
      const original = Workspace(id: 'a', name: 'A', unreadCount: 2);
      expect(original.copyWith(unreadCount: 5).name, 'A');
      expect(original.copyWith(unreadCount: 5).unreadCount, 5);
    });
  });
}
