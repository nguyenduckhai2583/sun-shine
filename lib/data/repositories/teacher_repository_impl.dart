import 'package:flutter/foundation.dart';

import '../../domain/models/teacher.dart';
import '../services/api/teacher_api_client.dart';
import 'teacher_repository.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  TeacherRepositoryImpl({required TeacherApiClient apiClient})
    : _apiClient = apiClient {
    debugPrint('[teachers] repository created');
  }

  final TeacherApiClient _apiClient;

  @override
  Future<List<Teacher>> getTeachers() async {
    final json = await _apiClient.fetchTeachers();
    return json.map(_toTeacher).toList();
  }

  @override
  Future<Teacher> getTeacher(String id) async =>
      _toTeacher(await _apiClient.fetchTeacher(id));

  Teacher _toTeacher(Map<String, Object?> json) => Teacher(
    id: json['id']! as String,
    name: json['full_name']! as String,
    email: json['email']! as String,
    subject: json['subject']! as String,
    yearsOfExperience: json['years_of_experience']! as int,
  );
}
