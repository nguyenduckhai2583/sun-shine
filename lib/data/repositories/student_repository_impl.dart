import 'package:flutter/foundation.dart';

import '../../domain/models/student.dart';
import '../services/api/student_api_client.dart';
import 'student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  StudentRepositoryImpl({required StudentApiClient apiClient})
    : _apiClient = apiClient;

  final StudentApiClient _apiClient;

  /// Per-user state, and the reason this repository lives in the session
  /// scope. There is deliberately no `clear()`: the cache dies when the
  /// scope that owns the repository is torn down at sign-out.
  ///
  /// Move this provider up to the app scope and the next user inherits this
  /// list — that is the Compass `UserRepositoryRemote._cachedData` bug.
  List<Student>? _cache;

  @override
  Future<List<Student>> getStudents() async {
    final cache = _cache;
    if (cache != null) {
      debugPrint('[students] list      -> cache hit (${cache.length})');
      return cache;
    }

    debugPrint('[students] list      -> cache MISS, calling the api');
    final json = await _apiClient.fetchStudents();
    return _cache = json.map(_toStudent).toList();
  }

  @override
  Future<Student> getStudent(String id) async {
    for (final student in _cache ?? const <Student>[]) {
      if (student.id == id) {
        debugPrint('[students] detail $id -> cache hit');
        return student;
      }
    }

    debugPrint('[students] detail $id -> cache MISS, calling the api');
    return _toStudent(await _apiClient.fetchStudent(id));
  }

  Student _toStudent(Map<String, Object?> json) => Student(
    id: json['id']! as String,
    name: json['full_name']! as String,
    email: json['email']! as String,
    className: json['class_name']! as String,
    gpa: (json['gpa']! as num).toDouble(),
  );
}
