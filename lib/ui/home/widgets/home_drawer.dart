import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  void _onWorkspaceSelected(BuildContext context, Workspace workspace) {
    context.read<HomeViewModel>().selectWorkspace(workspace.id);
    Scaffold.of(context).closeDrawer();
  }

  Future<void> _onSignOut(BuildContext context) async {
    Scaffold.of(context).closeDrawer();
    await context.read<AuthRepository>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 16, 8),
              child: Text(
                'Your workspaces',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: viewModel.load,
                builder: (context, _) {
                  if (viewModel.load.running) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.load.error) {
                    return ErrorIndicator(
                      title: 'Could not load workspaces',
                      onRetry: viewModel.load.execute,
                    );
                  }
                  return _WorkspaceList(
                    workspaces: viewModel.workspaces,
                    selectedId: viewModel.selectedWorkspace?.id,
                    onSelected: (w) => _onWorkspaceSelected(context, w),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () => _onSignOut(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceList extends StatelessWidget {
  const _WorkspaceList({
    required this.workspaces,
    required this.selectedId,
    required this.onSelected,
  });

  final List<Workspace> workspaces;
  final String? selectedId;
  final ValueChanged<Workspace> onSelected;

  @override
  Widget build(BuildContext context) {
    if (workspaces.isEmpty) {
      return const Center(child: Text('No workspaces yet'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: workspaces.length,
      itemBuilder: (context, index) {
        final workspace = workspaces[index];
        return _WorkspaceTile(
          workspace: workspace,
          isSelected: workspace.id == selectedId,
          onTap: () => onSelected(workspace),
        );
      },
    );
  }
}

class _WorkspaceTile extends StatelessWidget {
  const _WorkspaceTile({
    required this.workspace,
    required this.isSelected,
    required this.onTap,
  });

  final Workspace workspace;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      selected: isSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      selectedTileColor: colorScheme.secondaryContainer,
      leading: CircleAvatar(
        backgroundColor: isSelected
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
        foregroundColor: isSelected
            ? colorScheme.onPrimary
            : colorScheme.onSurfaceVariant,
        child: Text(workspace.initial),
      ),
      title: Text(workspace.name, overflow: TextOverflow.ellipsis),
      trailing: workspace.unreadCount > 0
          ? Badge(label: Text('${workspace.unreadCount}'))
          : null,
    );
  }
}
