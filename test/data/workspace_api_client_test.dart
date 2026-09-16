import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('WorkspaceApiClient', () {
    test('returns the workspace list', () async {
      final result = await WorkspaceApiClient().getWorkspaces();
      expect(result, isA<Ok<List<WorkspaceApiModel>>>());
      final workspaces = (result as Ok<List<WorkspaceApiModel>>).value;
      expect(workspaces, hasLength(3));
      expect(workspaces.first.id, 'ws_1');
      expect(workspaces.first.badgeCount, 3);
    });
  });
}
