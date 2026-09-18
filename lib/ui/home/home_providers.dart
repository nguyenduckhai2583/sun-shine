import 'package:provider/single_child_widget.dart';
import 'package:sun_shine/core.dart';

List<SingleChildWidget> get homeProviders {
  return [
    trackedProvider((context) => WorkspaceApiClient()),
    trackedProvider<WorkspaceRepository>(
      (context) => WorkspaceRepositoryRemote(apiClient: context.read()),
    ),
    trackedViewModel(
      (context) => HomeViewModel(workspaceRepository: context.read()),
    ),
  ];
}
