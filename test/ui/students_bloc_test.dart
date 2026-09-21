import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/data/repositories/student_repository_impl.dart';
import 'package:sun_shine/data/services/api/student_api_client.dart';
import 'package:sun_shine/data/services/local/student_local_service.dart';
import 'package:sun_shine/ui/student/bloc/students_bloc.dart';

void main() {
  late StudentLocalService local;
  late StudentsBloc bloc;

  setUp(() {
    local = StudentLocalService();
    bloc = StudentsBloc(
      repository: StudentRepositoryImpl(
        apiClient: StudentApiClient(),
        localService: local,
      ),
    );
    addTearDown(() async {
      await bloc.close();
      local.dispose();
    });
  });

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 400));

  test('typing fast produces exactly one search', () async {
    final queries = <String>[];
    bloc.stream.listen((state) {
      if (state.query.isNotEmpty) queries.add(state.query);
    });

    bloc
      ..add(const StudentsSearchChanged('a'))
      ..add(const StudentsSearchChanged('an'))
      ..add(const StudentsSearchChanged('ann'));
    await settle();

    expect(queries, [
      'ann',
    ], reason: 'debounceTime drops every event but the last of the burst');
  });

  test('a pause between queries produces two searches', () async {
    final queries = <String>[];
    bloc.stream.listen((state) {
      if (state.query.isNotEmpty) queries.add(state.query);
    });

    bloc.add(const StudentsSearchChanged('an'));
    await settle();
    bloc.add(const StudentsSearchChanged('chi'));
    await settle();

    expect(queries, ['an', 'chi']);
  });

  test('the query filters the loaded list, by name or class', () async {
    await settle();
    expect(bloc.state.students, hasLength(5));

    bloc.add(const StudentsSearchChanged('chi'));
    await settle();
    expect(bloc.state.visibleStudents.single.name, 'Chi Pham');

    bloc.add(const StudentsSearchChanged('10A1'));
    await settle();
    expect(bloc.state.visibleStudents, hasLength(2));

    bloc.add(const StudentsSearchChanged(''));
    await settle();
    expect(bloc.state.visibleStudents, hasLength(5));
  });
}
