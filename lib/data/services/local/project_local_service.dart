import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sun_shine/core.dart';

class ProjectLocalService extends BaseLocalService {
  final _projects = BehaviorSubject<List<Project>>.seeded(const []);

  Stream<List<Project>> get projects => _projects.stream;

  List<Project> get value => _projects.value;

  Stream<Project?> watch(String projectId) => _projects.stream
      .map((list) => list.firstWhereOrNull((p) => p.id == projectId))
      .distinct();

  Project? projectById(String projectId) =>
      _projects.value.firstWhereOrNull((p) => p.id == projectId);

  void replaceAll(List<Project> projects) {
    _projects.add(List.unmodifiable(projects));
  }

  void upsert(Project project) {
    final current = List<Project>.from(_projects.value);
    final index = current.indexWhere((p) => p.id == project.id);
    if (index == -1) {
      current.add(project);
    } else {
      if (current[index] == project) return;
      current[index] = project;
    }
    _projects.add(List.unmodifiable(current));
  }

  void clear() {
    _projects.add(const []);
  }

  bool get isDisposed => _projects.isClosed;

  @override
  void dispose() {
    _projects.close();
    super.dispose();
  }
}
