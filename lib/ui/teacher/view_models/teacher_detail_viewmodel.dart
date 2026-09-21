import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/repositories/teacher_repository.dart';
import '../../../domain/models/teacher.dart';

class TeacherDetailViewModel extends ChangeNotifier {
  TeacherDetailViewModel({
    required String teacherId,
    required TeacherRepository repository,
  }) : _teacherId = teacherId,
       _repository = repository {
    _subscription = _repository.watchTeacher(_teacherId).listen(_onTeacher);
  }

  final String _teacherId;
  final TeacherRepository _repository;

  late final StreamSubscription<Teacher?> _subscription;

  Teacher? _teacher;
  Teacher? get teacher => _teacher;

  Future<void> load() => _repository.loadTeacher(_teacherId);

  void _onTeacher(Teacher? teacher) {
    _teacher = teacher;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
