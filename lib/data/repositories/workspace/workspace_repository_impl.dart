import 'package:sun_shine/core.dart';

class WorkspaceRepositoryImpl extends BaseRepo implements WorkspaceRepository {
  WorkspaceRepositoryImpl({
    required WorkspaceApiClient apiClient,
    required WorkspaceLocalService localService,
  }) : _apiClient = apiClient,
       _localService = localService;

  final WorkspaceApiClient _apiClient;
  final WorkspaceLocalService _localService;

  @override
  Stream<Map<String, List<Workspace>>> get workspacesByAccount =>
      _localService.workspacesByAccount;

  @override
  Stream<List<Workspace>> watchWorkspacesOf(String accountUserId) =>
      _localService.watchWorkspacesOf(accountUserId);

  @override
  List<Workspace> workspacesOf(String accountUserId) =>
      _localService.workspacesOf(accountUserId);

  @override
  Future<void> restore() => _localService.restore();

  @override
  Future<Result<List<Workspace>>> refresh(
    String accountUserId, {
    String? token,
  }) async {
    final result = token == null
        ? await _apiClient.getWorkspaces()
        : await _apiClient.getWorkspacesForToken('Bearer $token');

    switch (result) {
      case Ok<List<WorkspaceApiModel>>():
        final workspaces = result.value.map(_toDomain).toList();
        await _localService.setWorkspaces(accountUserId, workspaces);
        return Result.ok(workspaces);
      case Error<List<WorkspaceApiModel>>():
        return Result.error(result.error);
    }
  }

  @override
  Future<void> removeAccount(String accountUserId) =>
      _localService.removeAccount(accountUserId);

  @override
  Future<void> pruneExcept(Set<String> accountUserIds) =>
      _localService.pruneExcept(accountUserIds);

  @override
  Future<void> clear() => _localService.clear();

  Workspace _toDomain(WorkspaceApiModel model) =>
      Workspace(id: model.id, name: model.name);
}
