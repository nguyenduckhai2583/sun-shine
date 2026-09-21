import 'package:flutter/foundation.dart';

import '../../domain/models/student.dart';
import '../services/api/student_api_client.dart';
import '../services/local/student_local_service.dart';
import 'student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  StudentRepositoryImpl({
    required StudentApiClient apiClient,
    required StudentLocalService localService,
  }) : _apiClient = apiClient,
       _localService = localService;

  final StudentApiClient _apiClient;
  final StudentLocalService _localService;

  /// Replaces the old `_cache` field. The cached data now lives in the local
  /// service; this only remembers whether the full list was fetched.
  bool _loadedAll = false;

  @override
  Stream<List<Student>> get students => _localService.students;

  @override
  Stream<Student?> watchStudent(String id) => _localService.watch(id);

  @override
  Future<void> loadStudents() async {
    if (_loadedAll) {
      debugPrint('[students] list      -> already loaded');
      return;
    }

    debugPrint('[students] list      -> calling the api');
    final json = await _apiClient.fetchStudents();
    _localService.replaceAll(json.map(_toStudent).toList());
    _loadedAll = true;
  }

  @override
  Future<void> loadStudent(String id) async {
    if (_hasLocally(id)) {
      debugPrint('[students] detail $id -> already local');
      return;
    }

    debugPrint('[students] detail $id -> calling the api');
    _localService.upsert(_toStudent(await _apiClient.fetchStudent(id)));
  }

  bool _hasLocally(String id) =>
      _localService.value.any((student) => student.id == id);

  Student _toStudent(Map<String, Object?> json) => Student(
    id: json['id']! as String,
    name: json['full_name']! as String,
    email: json['email']! as String,
    className: json['class_name']! as String,
    gpa: (json['gpa']! as num).toDouble(),
  );
}
