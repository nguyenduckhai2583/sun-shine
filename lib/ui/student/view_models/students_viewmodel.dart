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

  List<Student> _students = const [];
  List<Student> get students => _students;

  Future<void> load() => _repository.loadStudents();

  void _onStudents(List<Student> students) {
    _students = students;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
