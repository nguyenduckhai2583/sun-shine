import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/data/repositories/student_repository_impl.dart';
import 'package:sun_shine/data/services/api/student_api_client.dart';
import 'package:sun_shine/data/services/local/student_local_service.dart';
import 'package:sun_shine/domain/models/student.dart';

void main() {
  late _CountingStudentApiClient api;
  late StudentLocalService local;
  late StudentRepositoryImpl repository;

  setUp(() {
    api = _CountingStudentApiClient();
    local = StudentLocalService();
    repository = StudentRepositoryImpl(apiClient: api, localService: local);
    addTearDown(local.dispose);
  });

  test(
    'loadStudents calls the api once and publishes to the local service',
    () async {
      await repository.loadStudents();
      await repository.loadStudents();

      expect(api.listCalls, 1);
      expect(local.value.length, 2);
    },
  );

  test('a detail already in the local service never hits the api', () async {
    await repository.loadStudents();
    await repository.loadStudent('s-2');

    expect(api.detailCalls, 0);
  });

  test('a detail that is not local falls through to the api', () async {
    await repository.loadStudent('s-2');

    expect(api.detailCalls, 1);
    expect(local.value.single.name, 'Binh Tran');
  });

  // The point of the local service: one write, every subscriber sees it.
  test('a write reaches a subscriber that is already listening', () async {
    final seen = <String?>[];
    final subscription = repository
        .watchStudent('s-1')
        .listen((student) => seen.add(student?.name));
    addTearDown(subscription.cancel);

    await repository.loadStudents();
    local.upsert(
      const Student(
        id: 's-1',
        name: 'An Nguyen (renamed)',
        email: 'an@sunshine.edu',
        className: '10A1',
        gpa: 8.7,
      ),
    );
    await pumpEventQueue();

    expect(seen, [null, 'An Nguyen', 'An Nguyen (renamed)']);
  });

  // What the session scope buys: sign-out disposes both, so the next user
  // gets an empty local service and a repository that must refetch.
  test('a fresh instance starts empty', () async {
    await repository.loadStudents();
    expect(api.listCalls, 1);

    final next = StudentLocalService();
    addTearDown(next.dispose);
    await StudentRepositoryImpl(
      apiClient: api,
      localService: next,
    ).loadStudents();

    expect(api.listCalls, 2);
    expect(next.value.length, 2);
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
