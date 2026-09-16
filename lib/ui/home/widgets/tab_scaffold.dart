import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class TabScaffold extends StatelessWidget {
  const TabScaffold({super.key, required this.tab, required this.body});

  final HomeTab tab;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: _Title(fallback: tab.label),
      ),
      body: body,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.fallback});

  final String fallback;

  @override
  Widget build(BuildContext context) {
    final workspaceName = context.select<HomeViewModel, String?>(
      (viewModel) => viewModel.selectedWorkspace?.name,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(workspaceName ?? fallback),
        if (workspaceName != null)
          Text(fallback, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
