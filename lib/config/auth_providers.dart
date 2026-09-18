import 'package:provider/single_child_widget.dart';
import 'package:sun_shine/core.dart';

List<SingleChildWidget> get authProviders {
  return [
    trackedProvider((context) => AuthApiClient()),
    trackedProvider(
      (context) => AuthLocalService(),
      dispose: (service) => service.dispose(),
    ),
    trackedProvider<AuthRepository>(
      (context) => AuthRepositoryRemote(
        apiClient: context.read(),
        localService: context.read(),
      ),
    ),
  ];
}
