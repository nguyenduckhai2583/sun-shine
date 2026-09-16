import 'package:sun_shine/core.dart';

class FakeWorkspaceApiClient implements WorkspaceApiClient {
  FakeWorkspaceApiClient({List<WorkspaceApiModel>? workspaces, this.failure})
    : workspaces = workspaces ?? defaultWorkspaces;

  static const defaultWorkspaces = [
    WorkspaceApiModel(id: 'ws_1', name: 'Sun Shine', badgeCount: 3),
    WorkspaceApiModel(id: 'ws_2', name: 'Design Team'),
  ];

  List<WorkspaceApiModel> workspaces;
  Exception? failure;

  int getWorkspacesCallCount = 0;

  @override
  Future<Result<List<WorkspaceApiModel>>> getWorkspaces() async {
    getWorkspacesCallCount++;
    final failure = this.failure;
    if (failure != null) return Result.error(failure);
    return Result.ok(workspaces);
  }
}
