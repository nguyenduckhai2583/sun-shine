import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('WorkspaceApiModel', () {
    test('deserializes the camelCase wire format', () {
      final model = WorkspaceApiModel.fromJson(const {
        'id': 'ws_1',
        'name': 'Sun Shine',
        'isActive': false,
      });

      expect(model.id, 'ws_1');
      expect(model.name, 'Sun Shine');
      expect(model.isActive, isFalse);
    });

    test('treats a workspace as active when the key is absent', () {
      final model = WorkspaceApiModel.fromJson(const {
        'id': 'ws_1',
        'name': 'Sun Shine',
      });

      expect(model.isActive, isTrue);
    });

    test('ignores fields the app does not use yet', () {
      final model = WorkspaceApiModel.fromJson(const {
        'id': 'ws_1',
        'name': 'Sun Shine',
        'logo': {'signedUrl': 'https://cdn.invalid/logo.png'},
        'subdomain': 'sunshine',
      });

      expect(model.id, 'ws_1');
    });

    test('round-trips through json', () {
      const original = WorkspaceApiModel(id: 'ws_1', name: 'Sun Shine');

      expect(WorkspaceApiModel.fromJson(original.toJson()), original);
    });
  });
}
