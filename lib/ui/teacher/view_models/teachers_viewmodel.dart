import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/repositories/teacher_repository.dart';
import '../../../domain/models/teacher.dart';

class TeachersViewModel extends ChangeNotifier {
  TeachersViewModel({required TeacherRepository repository})
    : _repository = repository {
    _subscription = _repository.teachers.listen(_onTeachers);
  }

  final TeacherRepository _repository;

  late final StreamSubscription<List<Teacher>> _subscription;

  Timer? _debounce;

  List<Teacher> _teachers = const [];

  String _query = '';
  String get query => _query;

  /// Stored, not derived — the other half of the comparison with
  /// [StudentsViewModel.visibleStudents].
  ///
  /// A ChangeNotifier has no constructor to hide the recompute in, so the
  /// only way to keep this honest is that BOTH inputs funnel through
  /// [_recompute]. Add a third input and forget to call it, and this field
  /// silently goes stale.
  List<Teacher> _filteredTeachers = const [];
  List<Teacher> get filteredTeachers => _filteredTeachers;

  Future<void> load() => _repository.loadTeachers();

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _onQuery(query));
  }

  void _onQuery(String query) {
    _query = query;
    _recompute();
  }

  void _onTeachers(List<Teacher> teachers) {
    _teachers = teachers;
    _recompute();
  }

  void _recompute() {
    if (_query.isEmpty) {
      _filteredTeachers = _teachers;
    } else {
      final needle = _query.toLowerCase();
      _filteredTeachers = _teachers
          .where(
            (teacher) =>
                teacher.name.toLowerCase().contains(needle) ||
                teacher.subject.toLowerCase().contains(needle),
          )
          .toList();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _debounce?.cancel();
    super.dispose();
  }
}
