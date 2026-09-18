import 'dart:async';

import 'package:sun_shine/core.dart';

class PlanixProjectsViewModel extends BaseViewModel {
  PlanixProjectsViewModel({required ProjectRepository projectRepository})
    : _projectRepository = projectRepository {
    _subscription = _projectRepository.projects.listen(_onProjects);
    load = Command0(_load)..execute();
  }

  final ProjectRepository _projectRepository;

  late final StreamSubscription<List<Project>> _subscription;

  late final Command0<List<Project>> load;

  List<Project> _projects = const [];

  List<Project> get projects => List.unmodifiable(_projects);

  void _onProjects(List<Project> projects) {
    _projects = projects;
    notifyListeners();
  }

  Future<Result<List<Project>>> _load() => _projectRepository.loadProjects();

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
