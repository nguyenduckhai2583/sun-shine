import 'package:flutter/foundation.dart';

import '../../../data/repositories/teacher_repository.dart';
import '../../../domain/models/teacher.dart';

class TeacherDetailViewModel extends ChangeNotifier {
  TeacherDetailViewModel({
    required String teacherId,
    required TeacherRepository repository,
  }) : _teacherId = teacherId,
       _repository = repository;

  final String _teacherId;
  final TeacherRepository _repository;

  Teacher? _teacher;
  Teacher? get teacher => _teacher;

  Future<void> load() async {
    _teacher = await _repository.getTeacher(_teacherId);
    notifyListeners();
  }
}
