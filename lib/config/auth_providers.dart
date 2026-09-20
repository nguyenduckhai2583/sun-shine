import 'package:provider/single_child_widget.dart';
import 'package:sun_shine/core.dart';

List<SingleChildWidget> get authProviders {
  return [
    Provider(create: (context) => AuthApiClient()),
    Provider(
      create: (context) => AuthLocalService(),
      dispose: (context, service) => service.dispose(),
    ),
    Provider<AuthRepository>(
      create: (context) => AuthRepositoryImpl(
        apiClient: context.read(),
        localService: context.read(),
      ),
    ),
  ];
}
