import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/data/repositories/teacher_repository_impl.dart';
import 'package:sun_shine/data/services/api/teacher_api_client.dart';
import 'package:sun_shine/data/services/local/teacher_local_service.dart';
import 'package:sun_shine/domain/models/teacher.dart';
import 'package:sun_shine/ui/teacher/bloc/teachers_bloc.dart';

void main() {
  late TeacherLocalService local;
  late TeachersBloc bloc;

  setUp(() {
    local = TeacherLocalService();
    bloc = TeachersBloc(
      repository: TeacherRepositoryImpl(
        apiClient: TeacherApiClient(),
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
      ..add(const TeachersSearchChanged('m'))
      ..add(const TeachersSearchChanged('ma'))
      ..add(const TeachersSearchChanged('mai'));
    await settle();

    expect(queries, ['mai']);
  });

  test('the query filters by name or subject', () async {
    await settle();
    expect(bloc.state.teachers, hasLength(4));

    bloc.add(const TeachersSearchChanged('mai'));
    await settle();
    expect(bloc.state.filteredTeachers.single.name, 'Mai Hoang');

    bloc.add(const TeachersSearchChanged('physics'));
    await settle();
    expect(bloc.state.filteredTeachers.single.name, 'Khai Nguyen');

    bloc.add(const TeachersSearchChanged(''));
    await settle();
    expect(bloc.state.filteredTeachers, hasLength(4));
  });

  test('filteredTeachers is recomputed by the constructor, never set', () {
    final loaded = TeachersState(
      teachers: const [
        Teacher(
          id: 't-1',
          name: 'Mai Hoang',
          email: 'mai@sunshine.edu',
          subject: 'Mathematics',
          yearsOfExperience: 12,
        ),
      ],
    );
    expect(loaded.filteredTeachers, hasLength(1));

    // copyWith goes back through the constructor, so the field follows.
    expect(loaded.copyWith(query: 'zzz').filteredTeachers, isEmpty);
    expect(loaded.copyWith(query: 'math').filteredTeachers, hasLength(1));
  });

  test('state equality uses the inputs, not the derived field', () {
    final a = TeachersState(query: 'mai');
    final b = TeachersState(query: 'mai');
    final c = TeachersState(query: 'lan');

    expect(a, b);
    expect(a, isNot(c));
  });
}
