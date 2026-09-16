import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                error?.toString() ?? 'Unknown routing error',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go(Routes.home),
                child: const Text('Go home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
