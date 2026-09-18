import 'package:sun_shine/core.dart';

class ProjectNotFoundException implements Exception {
  const ProjectNotFoundException(this.projectId);

  final String projectId;

  @override
  String toString() => 'ProjectNotFoundException($projectId)';
}

class InvalidProjectNameException implements Exception {
  const InvalidProjectNameException(this.name);

  final String name;

  @override
  String toString() => 'InvalidProjectNameException($name)';
}

class ProjectApiClient {
  final _projects = <Map<String, Object>>[
    {'id': 'sun', 'name': 'Sun Shine', 'key': 'sun', 'open_tasks': 12},
    {'id': 'hplix', 'name': 'Hplix Platform', 'key': 'hpx', 'open_tasks': 47},
    {'id': 'mobile', 'name': 'Mobile Revamp', 'key': 'mob', 'open_tasks': 5},
  ];

  Future<Result<List<ProjectApiModel>>> getProjects() async {
    try {
      return Result.ok(_projects.map(ProjectApiModel.fromJson).toList());
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<ProjectApiModel>> getProject(String projectId) async {
    try {
      final index = _indexOf(projectId);
      if (index < 0) return Result.error(ProjectNotFoundException(projectId));
      return Result.ok(ProjectApiModel.fromJson(_projects[index]));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<ProjectApiModel>> updateProjectName(
    String projectId,
    String name,
  ) async {
    try {
      final trimmed = name.trim();
      if (trimmed.isEmpty) {
        return Result.error(InvalidProjectNameException(name));
      }
      final index = _indexOf(projectId);
      if (index < 0) return Result.error(ProjectNotFoundException(projectId));

      _projects[index] = {..._projects[index], 'name': trimmed};
      return Result.ok(ProjectApiModel.fromJson(_projects[index]));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  int _indexOf(String projectId) =>
      _projects.indexWhere((project) => project['id'] == projectId);
}
