import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class PlanixProjectsScreen extends StatelessWidget {
  const PlanixProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              PlanixProjectsViewModel(projectRepository: context.read()),
        ),
      ],
      child: const _PlanixProjectsView(),
    );
  }
}

class _PlanixProjectsView extends StatelessWidget {
  const _PlanixProjectsView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PlanixProjectsViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: const Text('Planix'),
      ),
      body: ListenableBuilder(
        listenable: viewModel.load,
        builder: (context, _) {
          if (viewModel.load.running) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.load.error) {
            return ErrorIndicator(
              title: 'Could not load projects',
              onRetry: viewModel.load.execute,
            );
          }
          return _ProjectList(projects: viewModel.projects);
        },
      ),
    );
  }
}

class _ProjectList extends StatelessWidget {
  const _ProjectList({required this.projects});

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) {
      return const Center(child: Text('No projects yet'));
    }

    return ListView.separated(
      itemCount: projects.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final project = projects[index];
        return ListTile(
          onTap: () => context.push(Routes.planixProject(project.id)),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
            child: Text(
              project.displayKey,
              style: const TextStyle(fontSize: 11),
            ),
          ),
          title: Text(project.name),
          subtitle: Text('${project.openTasks} open tasks'),
          trailing: const Icon(Icons.chevron_right),
        );
      },
    );
  }
}
