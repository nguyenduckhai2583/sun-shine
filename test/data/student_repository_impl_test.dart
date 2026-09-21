import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/data/repositories/student_repository_impl.dart';
import 'package:sun_shine/data/services/api/student_api_client.dart';

void main() {
  late _CountingStudentApiClient api;

  setUp(() => api = _CountingStudentApiClient());

  test('the second read of the list is served from the cache', () async {
    final repository = StudentRepositoryImpl(apiClient: api);

    await repository.getStudents();
    await repository.getStudents();

    expect(api.listCalls, 1);
  });

  test('a detail is served from the cached list', () async {
    final repository = StudentRepositoryImpl(apiClient: api);

    await repository.getStudents();
    final student = await repository.getStudent('s-2');

    expect(student.name, 'Binh Tran');
    expect(api.detailCalls, 0, reason: 'the list already had it');
  });

  test('a detail with no list loaded falls through to the api', () async {
    final repository = StudentRepositoryImpl(apiClient: api);

    await repository.getStudent('s-2');

    expect(api.detailCalls, 1);
  });

  // This is what the session scope buys: sign-out disposes the repository,
  // so the next user gets one of these — empty. Nothing had to remember to
  // clear anything.
  test('a fresh instance starts with an empty cache', () async {
    await StudentRepositoryImpl(apiClient: api).getStudents();
    expect(api.listCalls, 1);

    await StudentRepositoryImpl(apiClient: api).getStudents();
    expect(api.listCalls, 2, reason: 'a new session must refetch');
  });
}

class _CountingStudentApiClient implements StudentApiClient {
  int listCalls = 0;
  int detailCalls = 0;

  final _students = const [
    {
      'id': 's-1',
      'full_name': 'An Nguyen',
      'email': 'an@sunshine.edu',
      'class_name': '10A1',
      'gpa': 8.7,
    },
    {
      'id': 's-2',
      'full_name': 'Binh Tran',
      'email': 'binh@sunshine.edu',
      'class_name': '10A1',
      'gpa': 7.9,
    },
  ];

  @override
  Future<List<Map<String, Object?>>> fetchStudents() async {
    listCalls++;
    return _students;
  }

  @override
  Future<Map<String, Object?>> fetchStudent(String id) async {
    detailCalls++;
    return _students.firstWhere((student) => student['id'] == id);
  }
}
