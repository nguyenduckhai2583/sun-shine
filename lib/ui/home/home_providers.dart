import 'package:provider/single_child_widget.dart';
import 'package:sun_shine/core.dart';

List<SingleChildWidget> get homeProviders {
  return [
    Provider(create: (context) => WorkspaceApiClient()),
    Provider<WorkspaceRepository>(
      create: (context) =>
          WorkspaceRepositoryRemote(apiClient: context.read()),
    ),
    ChangeNotifierProvider(
      create: (context) => HomeViewModel(workspaceRepository: context.read()),
    ),
  ];
}
