import 'package:sun_shine/core.dart';

class ProjectRepositoryImpl extends BaseRepo implements ProjectRepository {
  ProjectRepositoryImpl({
    required ProjectApiClient apiClient,
    required ProjectLocalService localService,
  }) : _apiClient = apiClient,
       _localService = localService;

  final ProjectApiClient _apiClient;
  final ProjectLocalService _localService;

  bool _loadedAll = false;

  @override
  Stream<List<Project>> get projects => _localService.projects;

  @override
  Stream<Project?> watchProject(String projectId) =>
      _localService.watch(projectId);

  @override
  Future<Result<List<Project>>> loadProjects() async {
    if (_loadedAll) return Result.ok(_localService.value);

    final result = await _apiClient.getProjects();
    switch (result) {
      case Ok<List<ProjectApiModel>>():
        final projects = result.value.map(_toDomain).toList();
        _localService.replaceAll(projects);
        _loadedAll = true;
        return Result.ok(projects);
      case Error<List<ProjectApiModel>>():
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<Project>> loadProject(String projectId) async {
    final cached = _localService.projectById(projectId);
    if (cached != null) return Result.ok(cached);

    final result = await _apiClient.getProject(projectId);
    switch (result) {
      case Ok<ProjectApiModel>():
        final project = _toDomain(result.value);
        _localService.upsert(project);
        return Result.ok(project);
      case Error<ProjectApiModel>():
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<Project>> updateProjectName(
    String projectId,
    String name,
  ) async {
    final result = await _apiClient.updateProjectName(projectId, name);
    switch (result) {
      case Ok<ProjectApiModel>():
        final project = _toDomain(result.value);
        _localService.upsert(project);
        return Result.ok(project);
      case Error<ProjectApiModel>():
        return Result.error(result.error);
    }
  }

  @override
  void invalidateCache() {
    _loadedAll = false;
    _localService.clear();
  }

  Project _toDomain(ProjectApiModel model) {
    return Project(
      id: model.id,
      name: model.name,
      key: model.key,
      openTasks: model.openTasks,
    );
  }
}
