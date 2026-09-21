import 'package:rxdart/rxdart.dart';

import '../../../domain/models/student.dart';

/// In-memory source of truth for students.
///
/// The repository talks to the API; this holds what the app currently
/// believes. Every screen reads the same stream, so one write updates all of
/// them with no pop result and no manual refresh.
class StudentLocalService {
  final _students = BehaviorSubject<List<Student>>.seeded(const []);

  Stream<List<Student>> get students => _students.stream;

  List<Student> get value => _students.value;

  /// Ends in `.distinct()` so an unchanged value never wakes the UI.
  Stream<Student?> watch(String id) =>
      _students.stream.map((students) => _find(students, id)).distinct();

  void replaceAll(List<Student> students) {
    if (_students.value == students) return;
    _students.add(students);
  }

  void upsert(Student student) {
    final current = [..._students.value];
    final index = current.indexWhere((other) => other.id == student.id);
    if (index == -1) {
      current.add(student);
    } else {
      if (current[index] == student) return;
      current[index] = student;
    }
    _students.add(current);
  }

  void dispose() => _students.close();

  Student? _find(List<Student> students, String id) {
    for (final student in students) {
      if (student.id == id) return student;
    }
    return null;
  }
}
