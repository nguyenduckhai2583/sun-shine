import 'package:provider/single_child_widget.dart';
import 'package:sun_shine/core.dart';

List<SingleChildWidget> get planixModuleProviders {
  return [
    trackedProvider((context) => ProjectApiClient()),
    trackedProvider(
      (context) => ProjectLocalService(),
      dispose: (service) => service.dispose(),
    ),
    trackedProvider<ProjectRepository>(
      (context) => ProjectRepositoryRemote(
        apiClient: context.read(),
        localService: context.read(),
      ),
    ),
  ];
}

List<SingleChildWidget> get planixProjectsProviders {
  return [
    trackedViewModel(
      (context) => PlanixProjectsViewModel(projectRepository: context.read()),
    ),
  ];
}

List<SingleChildWidget> planixProjectDetailProviders(String projectId) {
  return [
    trackedViewModel(
      (context) => PlanixProjectDetailViewModel(
        projectId: projectId,
        projectRepository: context.read(),
      ),
    ),
  ];
}
