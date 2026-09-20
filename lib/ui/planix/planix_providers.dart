import 'package:provider/single_child_widget.dart';
import 'package:sun_shine/core.dart';

List<SingleChildWidget> get planixModuleProviders {
  return [
    Provider(create: (context) => ProjectApiClient()),
    Provider(
      create: (context) => ProjectLocalService(),
      dispose: (context, service) => service.dispose(),
    ),
    Provider<ProjectRepository>(
      create: (context) => ProjectRepositoryImpl(
        apiClient: context.read(),
        localService: context.read(),
      ),
    ),
  ];
}

List<SingleChildWidget> get planixProjectsProviders {
  return [
    ChangeNotifierProvider(
      create: (context) =>
          PlanixProjectsViewModel(projectRepository: context.read()),
    ),
  ];
}

List<SingleChildWidget> planixProjectDetailProviders(String projectId) {
  return [
    ChangeNotifierProvider(
      create: (context) => PlanixProjectDetailViewModel(
        projectId: projectId,
        projectRepository: context.read(),
      ),
    ),
  ];
}
