import 'package:flutter/foundation.dart';

import '../../domain/models/teacher.dart';
import '../services/api/teacher_api_client.dart';
import '../services/local/teacher_local_service.dart';
import 'teacher_repository.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  TeacherRepositoryImpl({
    required TeacherApiClient apiClient,
    required TeacherLocalService localService,
  }) : _apiClient = apiClient,
       _localService = localService {
    debugPrint('[teachers] repository created');
  }

  final TeacherApiClient _apiClient;
  final TeacherLocalService _localService;

  bool _loadedAll = false;

  @override
  Stream<List<Teacher>> get teachers => _localService.teachers;

  @override
  Stream<Teacher?> watchTeacher(String id) => _localService.watch(id);

  @override
  Future<void> loadTeachers() async {
    if (_loadedAll) return;

    final json = await _apiClient.fetchTeachers();
    _localService.replaceAll(json.map(_toTeacher).toList());
    _loadedAll = true;
  }

  @override
  Future<void> loadTeacher(String id) async {
    if (_localService.value.any((teacher) => teacher.id == id)) return;

    _localService.upsert(_toTeacher(await _apiClient.fetchTeacher(id)));
  }

  Teacher _toTeacher(Map<String, Object?> json) => Teacher(
    id: json['id']! as String,
    name: json['full_name']! as String,
    email: json['email']! as String,
    subject: json['subject']! as String,
    yearsOfExperience: json['years_of_experience']! as int,
  );
}
