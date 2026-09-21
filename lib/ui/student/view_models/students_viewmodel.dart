import 'package:flutter/foundation.dart';

import '../../../data/repositories/student_repository.dart';
import '../../../domain/models/student.dart';

class StudentsViewModel extends ChangeNotifier {
  StudentsViewModel({required StudentRepository repository})
    : _repository = repository;

  final StudentRepository _repository;

  List<Student> _students = const [];
  List<Student> get students => _students;

  Future<void> load() async {
    _students = await _repository.getStudents();
    notifyListeners();
  }
}
