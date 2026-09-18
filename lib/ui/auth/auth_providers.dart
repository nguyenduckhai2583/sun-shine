import 'package:provider/single_child_widget.dart';
import 'package:sun_shine/core.dart';

List<SingleChildWidget> get signInProviders {
  return [
    trackedViewModel(
      (context) => SignInViewModel(authRepository: context.read()),
    ),
  ];
}
