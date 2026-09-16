import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      tab: HomeTab.more,
      body: PlaceholderTab(
        icon: Icons.more_horiz,
        title: 'More',
        message: 'Settings and everything else goes here.',
        action: FilledButton.tonal(
          onPressed: () => context.push(Routes.moreSettings),
          child: const Text('Open Settings (nested demo)'),
        ),
      ),
    );
  }
}
