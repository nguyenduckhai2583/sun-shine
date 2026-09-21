import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(
        watchAccountsUseCase: context.read(),
        selectWorkspaceUseCase: context.read(),
        refreshAccountWorkspacesUseCase: context.read(),
        signOutUseCase: context.read(),
        signInFlowUseCase: context.read(),
      ),
      child: _HomeScaffold(navigationShell: navigationShell),
    );
  }
}

class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTabSelected,
        destinations: [
          for (final tab in HomeTab.values)
            NavigationDestination(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }
}
