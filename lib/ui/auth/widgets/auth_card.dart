import 'package:material_ui/material_ui.dart';

/// The rounded panel the auth forms sit on.
class AuthCardWidget extends StatelessWidget {
  const AuthCardWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: child,
      ),
    );
  }
}
