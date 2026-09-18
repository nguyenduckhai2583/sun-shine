import 'package:sun_shine/core.dart';

class WorkspaceApiClient extends BaseApiClient {
  static const _sampleWorkspaces = [
    {'id': 'ws_1', 'name': 'Sun Shine', 'badge_count': 3},
    {'id': 'ws_2', 'name': 'Design Team', 'badge_count': 0},
    {'id': 'ws_3', 'name': 'Engineering', 'badge_count': 12},
  ];

  Future<Result<List<WorkspaceApiModel>>> getWorkspaces() async {
    try {
      final workspaces = _sampleWorkspaces
          .map(WorkspaceApiModel.fromJson)
          .toList();
      return Result.ok(workspaces);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
