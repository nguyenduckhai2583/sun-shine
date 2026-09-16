import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class DmsScreen extends StatelessWidget {
  const DmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabScaffold(
      tab: HomeTab.dms,
      body: PlaceholderTab(
        icon: Icons.forum_outlined,
        title: 'Messages',
        message: 'Direct message list goes here.',
      ),
    );
  }
}
