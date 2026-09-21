import 'package:rxdart/rxdart.dart';

import '../../../domain/models/teacher.dart';

/// In-memory source of truth for teachers.
///
/// The repository talks to the API; this holds what the app currently
/// believes. Every screen reads the same stream, so one write updates all of
/// them with no pop result and no manual refresh.
class TeacherLocalService {
  final _teachers = BehaviorSubject<List<Teacher>>.seeded(const []);

  Stream<List<Teacher>> get teachers => _teachers.stream;

  List<Teacher> get value => _teachers.value;

  /// Ends in `.distinct()` so an unchanged value never wakes the UI.
  Stream<Teacher?> watch(String id) =>
      _teachers.stream.map((teachers) => _find(teachers, id)).distinct();

  void replaceAll(List<Teacher> teachers) {
    if (_teachers.value == teachers) return;
    _teachers.add(teachers);
  }

  void upsert(Teacher teacher) {
    final current = [..._teachers.value];
    final index = current.indexWhere((other) => other.id == teacher.id);
    if (index == -1) {
      current.add(teacher);
    } else {
      if (current[index] == teacher) return;
      current[index] = teacher;
    }
    _teachers.add(current);
  }

  void dispose() => _teachers.close();

  Teacher? _find(List<Teacher> teachers, String id) {
    for (final teacher in teachers) {
      if (teacher.id == id) return teacher;
    }
    return null;
  }
}
