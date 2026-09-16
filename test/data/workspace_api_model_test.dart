import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('WorkspaceApiModel', () {
    test('deserializes the snake_case wire format', () {
      final model = WorkspaceApiModel.fromJson(const {
        'id': 'ws_1',
        'name': 'Sun Shine',
        'badge_count': 7,
      });
      expect(model.id, 'ws_1');
      expect(model.badgeCount, 7);
    });
    test('defaults badge_count when the key is absent', () {
      final model = WorkspaceApiModel.fromJson(const {
        'id': 'ws_1',
        'name': 'Sun Shine',
      });
      expect(model.badgeCount, 0);
    });
    test('round-trips through json', () {
      const original = WorkspaceApiModel(
        id: 'ws_1',
        name: 'Sun Shine',
        badgeCount: 7,
      );
      expect(WorkspaceApiModel.fromJson(original.toJson()), original);
    });
  });
}
