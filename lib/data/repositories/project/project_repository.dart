import 'package:sun_shine/core.dart';

abstract class ProjectRepository {
  Stream<List<Project>> get projects;

  Stream<Project?> watchProject(String projectId);

  Future<Result<List<Project>>> loadProjects();

  Future<Result<Project>> loadProject(String projectId);

  Future<Result<Project>> updateProjectName(String projectId, String name);
}
