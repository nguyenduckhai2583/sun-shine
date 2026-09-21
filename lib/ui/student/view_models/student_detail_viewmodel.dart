import 'package:flutter/foundation.dart';

import '../../../data/repositories/student_repository.dart';
import '../../../domain/models/student.dart';

class StudentDetailViewModel extends ChangeNotifier {
  StudentDetailViewModel({
    required String studentId,
    required StudentRepository repository,
  }) : _studentId = studentId,
       _repository = repository;

  final String _studentId;
  final StudentRepository _repository;

  Student? _student;
  Student? get student => _student;

  Future<void> load() async {
    _student = await _repository.getStudent(_studentId);
    notifyListeners();
  }
}
