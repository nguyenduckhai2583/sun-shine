import 'package:sun_shine/core.dart';

class FakeWorkspaceRepository implements WorkspaceRepository {
  FakeWorkspaceRepository({List<Workspace>? workspaces, this.failure})
    : workspaces = workspaces ?? defaultWorkspaces;

  static const defaultWorkspaces = [
    Workspace(id: 'ws_1', name: 'Sun Shine', unreadCount: 3),
    Workspace(id: 'ws_2', name: 'Design Team'),
  ];

  List<Workspace> workspaces;
  Exception? failure;

  int getWorkspacesCallCount = 0;

  @override
  Future<Result<List<Workspace>>> getWorkspaces() async {
    getWorkspacesCallCount++;
    final failure = this.failure;
    if (failure != null) return Result.error(failure);
    return Result.ok(workspaces);
  }

  @override
  void invalidateCache() {}
}
