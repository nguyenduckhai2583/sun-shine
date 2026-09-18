import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class PlanixProjectDetailScreen extends StatelessWidget {
  const PlanixProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: planixProjectDetailProviders(projectId),
      child: const _PlanixProjectDetailView(),
    );
  }
}

class _PlanixProjectDetailView extends StatelessWidget {
  const _PlanixProjectDetailView();

  Future<void> _onRenamePressed(BuildContext context) async {
    final viewModel = context.read<PlanixProjectDetailViewModel>();
    final project = viewModel.project;
    if (project == null) return;

    final name = await showDialog<String>(
      context: context,
      builder: (context) => RenameDialog(
        title: 'Rename project',
        label: 'Name',
        initialValue: project.name,
      ),
    );
    if (name == null) return;

    await viewModel.rename.execute(name);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PlanixProjectDetailViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.project?.name ?? viewModel.projectId),
        actions: [
          if (viewModel.project != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Rename project',
              onPressed: viewModel.rename.running
                  ? null
                  : () => _onRenamePressed(context),
            ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel.load,
        builder: (context, _) {
          if (viewModel.load.running) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.load.error) {
            return ErrorIndicator(
              title: 'Could not load ${viewModel.projectId}',
              onRetry: viewModel.load.execute,
            );
          }
          return _ProjectBody(project: viewModel.project!);
        },
      ),
    );
  }
}

class _ProjectBody extends StatelessWidget {
  const _ProjectBody({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(project.name, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(project.displayKey, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(
              '${project.openTasks} open tasks',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
