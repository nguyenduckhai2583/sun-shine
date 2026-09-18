import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sun_shine/core.dart';

class PlanixProjectDetailViewModel extends ChangeNotifier {
  PlanixProjectDetailViewModel({
    required String projectId,
    required ProjectRepository projectRepository,
  }) : _projectId = projectId,
       _projectRepository = projectRepository {
    _subscription = _projectRepository
        .watchProject(_projectId)
        .listen(_onProject);
    load = Command0(_load)..execute();
    rename = Command1(_rename);
  }

  final String _projectId;
  final ProjectRepository _projectRepository;

  late final StreamSubscription<Project?> _subscription;

  String get projectId => _projectId;

  late final Command0<Project> load;

  late final Command1<Project, String> rename;

  Project? _project;

  Project? get project => _project;

  void _onProject(Project? project) {
    if (project == null) return;
    _project = project;
    notifyListeners();
  }

  Future<Result<Project>> _load() => _projectRepository.loadProject(_projectId);

  Future<Result<Project>> _rename(String name) =>
      _projectRepository.updateProjectName(_projectId, name);

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
