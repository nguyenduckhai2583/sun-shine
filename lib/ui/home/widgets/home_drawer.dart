import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  static const switchFailedMessage =
      'That session expired, so the account was removed.';

  Future<void> _onWorkspaceSelected(
    BuildContext context,
    AccountGroup account,
    Workspace workspace,
  ) async {
    final viewModel = context.read<HomeViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    Scaffold.of(context).closeDrawer();

    await viewModel.selectWorkspace.execute((
      accountUserId: account.session.userId,
      workspaceId: workspace.id,
    ));

    if (!viewModel.selectWorkspace.error) return;
    messenger.showSnackBar(const SnackBar(content: Text(switchFailedMessage)));
  }

  void _onAddAccount(BuildContext context) {
    Scaffold.of(context).closeDrawer();
    context.read<HomeViewModel>().addAccount();
  }

  Future<void> _onSignOut(BuildContext context) async {
    Scaffold.of(context).closeDrawer();
    await context.read<HomeViewModel>().signOutActive();
  }

  Future<void> _onSignOutAll(BuildContext context) async {
    Scaffold.of(context).closeDrawer();
    await context.read<HomeViewModel>().signOutAll();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListenableBuilder(
                listenable: viewModel.load,
                builder: (context, _) => _DrawerBody(
                  viewModel: viewModel,
                  onSelected: (account, workspace) =>
                      _onWorkspaceSelected(context, account, workspace),
                ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add another account'),
              onTap: () => _onAddAccount(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              subtitle: viewModel.hasMultipleAccounts
                  ? const Text('Switches to your next account')
                  : null,
              onTap: () => _onSignOut(context),
            ),
            if (viewModel.hasMultipleAccounts)
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign out of all accounts'),
                onTap: () => _onSignOutAll(context),
              ),
          ],
        ),
      ),
    );
  }
}

typedef _WorkspaceSelected = void Function(AccountGroup, Workspace);

class _DrawerBody extends StatelessWidget {
  const _DrawerBody({required this.viewModel, required this.onSelected});

  final HomeViewModel viewModel;
  final _WorkspaceSelected onSelected;

  bool get _isEmpty =>
      viewModel.accounts.every((account) => account.workspaces.isEmpty);

  @override
  Widget build(BuildContext context) {
    if (viewModel.load.running && _isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.load.error && _isEmpty) {
      return ErrorIndicator(
        title: 'Could not load workspaces',
        onRetry: viewModel.load.execute,
      );
    }

    if (!viewModel.hasMultipleAccounts) {
      final account = viewModel.activeAccount;
      return Column(
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
            child: _WorkspaceList(
              workspaces: account?.workspaces ?? const [],
              selectedId: viewModel.selectedWorkspaceId,
              onSelected: (workspace) => onSelected(account!, workspace),
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        for (final account in viewModel.accounts)
          _AccountSection(
            account: account,
            selectedWorkspaceId: viewModel.selectedWorkspaceId,
            onSelected: (workspace) => onSelected(account, workspace),
          ),
      ],
    );
  }
}

class _AccountSection extends StatefulWidget {
  const _AccountSection({
    required this.account,
    required this.selectedWorkspaceId,
    required this.onSelected,
  });

  final AccountGroup account;
  final String? selectedWorkspaceId;
  final ValueChanged<Workspace> onSelected;

  @override
  State<_AccountSection> createState() => _AccountSectionState();
}

class _AccountSectionState extends State<_AccountSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final account = widget.account;
    final user = account.session.user;
    final email = user?.email;
    final label = user?.fullName ?? email ?? account.session.userId;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          dense: true,
          onTap: () => setState(() => _expanded = !_expanded),
          leading: CircleAvatar(
            radius: 14,
            backgroundColor: account.isActive
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest,
            foregroundColor: account.isActive
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            child: Text(
              label.isEmpty ? '?' : label.substring(0, 1).toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          title: Text(label, overflow: TextOverflow.ellipsis),
          subtitle: email == null || email == label ? null : Text(email),
          trailing: Icon(
            _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          ),
        ),
        if (_expanded)
          for (final workspace in account.workspaces)
            _WorkspaceTile(
              workspace: workspace,
              isSelected:
                  account.isActive &&
                  workspace.id == widget.selectedWorkspaceId,
              onTap: () => widget.onSelected(workspace),
            ),
        const SizedBox(height: 8),
      ],
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
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
