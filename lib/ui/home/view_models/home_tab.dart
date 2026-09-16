import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

enum HomeTab {
  channels(label: 'Channels', icon: Icons.tag, location: Routes.channels),
  dms(label: 'Messages', icon: Icons.forum_outlined, location: Routes.dms),
  more(label: 'More', icon: Icons.more_horiz, location: Routes.more);

  const HomeTab({
    required this.label,
    required this.icon,
    required this.location,
  });

  final String label;

  final IconData icon;

  final String location;
}
