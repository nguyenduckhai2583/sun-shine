import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/repositories/student_repository.dart';
import '../../../domain/models/student.dart';

class StudentDetailViewModel extends ChangeNotifier {
  StudentDetailViewModel({
    required String studentId,
    required StudentRepository repository,
  }) : _studentId = studentId,
       _repository = repository {
    _subscription = _repository.watchStudent(_studentId).listen(_onStudent);
  }

  final String _studentId;
  final StudentRepository _repository;

  late final StreamSubscription<Student?> _subscription;

  Student? _student;
  Student? get student => _student;

  Future<void> load() => _repository.loadStudent(_studentId);

  void _onStudent(Student? student) {
    _student = student;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
