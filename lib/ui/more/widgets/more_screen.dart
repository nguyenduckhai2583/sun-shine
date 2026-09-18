import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      tab: HomeTab.more,
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Planix'),
            subtitle: const Text('Projects and tasks'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.planix),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.moreSettings),
          ),
        ],
      ),
    );
  }
}
