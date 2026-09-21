import 'package:flutter/foundation.dart';

import '../../../data/repositories/teacher_repository.dart';
import '../../../domain/models/teacher.dart';

class TeachersViewModel extends ChangeNotifier {
  TeachersViewModel({required TeacherRepository repository})
    : _repository = repository;

  final TeacherRepository _repository;

  List<Teacher> _teachers = const [];
  List<Teacher> get teachers => _teachers;

  Future<void> load() async {
    _teachers = await _repository.getTeachers();
    notifyListeners();
  }
}
