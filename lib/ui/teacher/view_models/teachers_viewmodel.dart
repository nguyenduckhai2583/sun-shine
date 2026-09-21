import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/repositories/teacher_repository.dart';
import '../../../domain/models/teacher.dart';

class TeachersViewModel extends ChangeNotifier {
  TeachersViewModel({required TeacherRepository repository})
    : _repository = repository {
    // Subscribe to the source of truth, then ask for a fetch. Any later
    // write to the local service arrives here without another load().
    _subscription = _repository.teachers.listen(_onTeachers);
  }

  final TeacherRepository _repository;

  late final StreamSubscription<List<Teacher>> _subscription;

  List<Teacher> _teachers = const [];
  List<Teacher> get teachers => _teachers;

  Future<void> load() => _repository.loadTeachers();

  void _onTeachers(List<Teacher> teachers) {
    _teachers = teachers;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
