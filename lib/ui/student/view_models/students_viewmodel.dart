import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/repositories/student_repository.dart';
import '../../../domain/models/student.dart';

class StudentsViewModel extends ChangeNotifier {
  StudentsViewModel({required StudentRepository repository})
    : _repository = repository {
    // Subscribe to the source of truth, then ask for a fetch. Any later
    // write to the local service arrives here without another load().
    _subscription = _repository.students.listen(_onStudents);
  }

  final StudentRepository _repository;

  late final StreamSubscription<List<Student>> _subscription;

  /// Debounce, wired by hand. With bloc this is one line on the handler
  /// (`transformer: debounce(...)`); a ChangeNotifier has no such seam.
  Timer? _debounce;

  List<Student> _students = const [];

  String _query = '';
  String get query => _query;

  /// What the list renders. Derived, so it can never go stale and is never
  /// stored twice.
  List<Student> get visibleStudents {
    if (_query.isEmpty) return _students;

    final needle = _query.toLowerCase();
    return _students
        .where(
          (student) =>
              student.name.toLowerCase().contains(needle) ||
              student.className.toLowerCase().contains(needle),
        )
        .toList();
  }

  Future<void> load() => _repository.loadStudents();

  /// Called on every keystroke. Each call cancels the timer the previous
  /// one started, so only 300ms of silence lets a query through.
  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _onQuery(query));
  }

  void _onQuery(String query) {
    debugPrint('[students] search -> "$query"');
    _query = query;
    notifyListeners();
  }

  void _onStudents(List<Student> students) {
    _students = students;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _debounce?.cancel();
    super.dispose();
  }
}
