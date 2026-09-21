import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkspaceViewModel(
        watchAccountsUseCase: context.read(),
        refreshAccountWorkspacesUseCase: context.read(),
        selectWorkspaceUseCase: context.read(),
        signOutUseCase: context.read(),
      ),
      child: const _WorkspaceView(),
    );
  }
}

class _WorkspaceView extends StatelessWidget {
  const _WorkspaceView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.colorScheme.surfaceContainerLowest,
      child: GridTileBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                children: [
                  // The whole page scrolls, so a short screen loses the
                  // header rather than silently clipping the workspace list.
                  const Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 24),
                          GlassIcon(
                            svgAsset: AppAsset.icAppIcon,
                            iconSizePercent: .4,
                          ),
                          SizedBox(height: 24),
                          _Title(),
                          SizedBox(height: 24),
                          _Body(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const _SignOutButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(l10n.selectWorkspace, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        Text(
          l10n.selectWorkspaceDesc,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<WorkspaceViewModel>();

    return ListenableBuilder(
      listenable: viewModel.load,
      builder: (context, _) {
        if (viewModel.load.running && viewModel.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: CircularProgressIndicator(),
          );
        }
        if (viewModel.load.error && viewModel.isEmpty) {
          return ErrorIndicator(
            title: l10n.couldNotLoadWorkspaces,
            onRetry: viewModel.load.execute,
          );
        }
        if (viewModel.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Text(
              l10n.noWorkspaceAvailable,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }
        return const _WorkspacePicker();
      },
    );
  }
}

class _WorkspacePicker extends StatelessWidget {
  const _WorkspacePicker();

  Future<void> _onSubmit(BuildContext context) async {
    final viewModel = context.read<WorkspaceViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);

    await viewModel.submit.execute();

    if (!viewModel.submit.error) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(switch (viewModel.submit.result) {
          Error(error: final ApiException e) => e.localizedMessage(l10n),
          _ => l10n.somethingWentWrong,
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<WorkspaceViewModel>();

    return AuthCardWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.workspaces.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final workspace = viewModel.workspaces[index];
              return _WorkspaceTile(
                workspace: workspace,
                isSelected: workspace.id == viewModel.selectedWorkspaceId,
                onTap: () => viewModel.select(workspace.id),
              );
            },
          ),
          const SizedBox(height: 24),
          ListenableBuilder(
            listenable: viewModel.submit,
            builder: (context, _) => SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: viewModel.canSubmit && !viewModel.submit.running
                    ? () => _onSubmit(context)
                    : null,
                child: viewModel.submit.running
                    ? Text(l10n.processing)
                    : Text(l10n.next),
              ),
            ),
          ),
        ],
      ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: CircleAvatar(
        backgroundColor: isSelected
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
        foregroundColor: isSelected
            ? colorScheme.onPrimary
            : colorScheme.onSurfaceVariant,
        child: Text(workspace.initial),
      ),
      title: Text(
        workspace.name,
        overflow: TextOverflow.ellipsis,
        style: isSelected
            ? theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSecondaryContainer,
              )
            : theme.textTheme.titleMedium,
      ),
      trailing: workspace.unreadCount > 0
          ? Badge(label: Text('${workspace.unreadCount}'))
          : null,
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return TextButton(
      onPressed: context.read<WorkspaceViewModel>().signOut,
      child: Text(l10n.signOut),
    );
  }
}
