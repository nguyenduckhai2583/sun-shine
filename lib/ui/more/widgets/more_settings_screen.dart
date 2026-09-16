import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class MoreSettingsScreen extends StatelessWidget {
  const MoreSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const PlaceholderTab(
        icon: Icons.settings_outlined,
        title: 'Settings',
        message:
            'Nested inside the More tab: the tab bar stays visible and this '
            'page belongs to the More tab back stack.',
      ),
    );
  }
}
