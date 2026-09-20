import 'package:sun_shine/core.dart';

class WorkspaceRepositoryImpl extends BaseRepo implements WorkspaceRepository {
  WorkspaceRepositoryImpl({required WorkspaceApiClient apiClient})
    : _apiClient = apiClient;

  final WorkspaceApiClient _apiClient;

  List<Workspace>? _cachedWorkspaces;

  @override
  Future<Result<List<Workspace>>> getWorkspaces() async {
    final cached = _cachedWorkspaces;
    if (cached != null) return Result.ok(cached);

    final result = await _apiClient.getWorkspaces();
    switch (result) {
      case Ok<List<WorkspaceApiModel>>():
        final workspaces = result.value.map(_toDomain).toList();
        _cachedWorkspaces = workspaces;
        return Result.ok(workspaces);
      case Error<List<WorkspaceApiModel>>():
        return Result.error(result.error);
    }
  }

  @override
  void invalidateCache() => _cachedWorkspaces = null;

  Workspace _toDomain(WorkspaceApiModel model) {
    return Workspace(
      id: model.id,
      name: model.name,
      unreadCount: model.badgeCount,
    );
  }
}
