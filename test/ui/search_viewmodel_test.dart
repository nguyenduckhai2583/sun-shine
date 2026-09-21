import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/data/repositories/student_repository_impl.dart';
import 'package:sun_shine/data/repositories/teacher_repository_impl.dart';
import 'package:sun_shine/data/services/api/student_api_client.dart';
import 'package:sun_shine/data/services/api/teacher_api_client.dart';
import 'package:sun_shine/data/services/local/student_local_service.dart';
import 'package:sun_shine/data/services/local/teacher_local_service.dart';
import 'package:sun_shine/ui/student/view_models/students_viewmodel.dart';
import 'package:sun_shine/ui/teacher/view_models/teachers_viewmodel.dart';

Future<void> settle() =>
    Future<void>.delayed(const Duration(milliseconds: 400));

void main() {
  group('StudentsViewModel — derived getter', () {
    late StudentsViewModel viewModel;

    setUp(() {
      final local = StudentLocalService();
      viewModel = StudentsViewModel(
        repository: StudentRepositoryImpl(
          apiClient: StudentApiClient(),
          localService: local,
        ),
      )..load();
      addTearDown(() {
        viewModel.dispose();
        local.dispose();
      });
    });

    test('typing fast notifies once, with the last query', () async {
      await settle();
      final queries = <String>[];
      viewModel.addListener(() => queries.add(viewModel.query));

      viewModel
        ..search('a')
        ..search('an')
        ..search('ann');
      await settle();

      expect(queries, ['ann']);
    });

    test('filters by name or class', () async {
      await settle();
      expect(viewModel.visibleStudents, hasLength(5));

      viewModel.search('chi');
      await settle();
      expect(viewModel.visibleStudents.single.name, 'Chi Pham');

      viewModel.search('10A1');
      await settle();
      expect(viewModel.visibleStudents, hasLength(2));

      viewModel.search('');
      await settle();
      expect(viewModel.visibleStudents, hasLength(5));
    });
  });

  group('TeachersViewModel — stored field', () {
    late TeachersViewModel viewModel;

    setUp(() {
      final local = TeacherLocalService();
      viewModel = TeachersViewModel(
        repository: TeacherRepositoryImpl(
          apiClient: TeacherApiClient(),
          localService: local,
        ),
      )..load();
      addTearDown(() {
        viewModel.dispose();
        local.dispose();
      });
    });

    test('filters by name or subject', () async {
      await settle();
      expect(viewModel.filteredTeachers, hasLength(4));

      viewModel.search('mai');
      await settle();
      expect(viewModel.filteredTeachers.single.name, 'Mai Hoang');

      viewModel.search('physics');
      await settle();
      expect(viewModel.filteredTeachers.single.name, 'Khai Nguyen');
    });

    // The risk of a stored field: it must follow BOTH inputs, not just the
    // query. Data arriving after a search has to be filtered too.
    test('new data arriving while a query is active is filtered too', () async {
      await settle();
      viewModel.search('mai');
      await settle();
      expect(viewModel.filteredTeachers, hasLength(1));

      // The repository refetches and pushes the list again.
      await viewModel.load();
      await settle();

      expect(
        viewModel.filteredTeachers,
        hasLength(1),
        reason: 'the stored field must be recomputed on new data, not reset',
      );
    });
  });
}
