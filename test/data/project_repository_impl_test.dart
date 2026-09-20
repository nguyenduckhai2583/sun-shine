import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('ProjectRepositoryImpl', () {
    late ProjectLocalService localService;
    late ProjectRepositoryImpl repository;

    setUp(() {
      localService = ProjectLocalService();
      repository = ProjectRepositoryImpl(
        apiClient: ProjectApiClient(),
        localService: localService,
      );
      addTearDown(localService.dispose);
    });

    test('maps api models onto domain models', () async {
      final result = await repository.loadProject('sun');

      expect(result, isA<Ok<Project>>());
      final project = (result as Ok<Project>).value;
      expect(project.name, 'Sun Shine');
      expect(project.displayKey, 'SUN');
      expect(project.openTasks, 12);
    });

    test('errors for an unknown project', () async {
      final result = await repository.loadProject('nope');

      expect(result, isA<Error<Project>>());
      expect((result as Error<Project>).error, isA<ProjectNotFoundException>());
    });

    test('a list read warms the per-id cache', () async {
      await repository.loadProjects();
      final result = await repository.loadProject('hplix');

      expect((result as Ok<Project>).value.name, 'Hplix Platform');
    });

    test('renaming emits on watchProject', () async {
      await repository.loadProjects();

      expect(
        repository.watchProject('sun'),
        emitsInOrder([
          isA<Project>().having((p) => p.name, 'name', 'Sun Shine'),
          isA<Project>().having((p) => p.name, 'name', 'Sun Shine v2'),
        ]),
      );

      await repository.updateProjectName('sun', 'Sun Shine v2');
    });

    test('renaming emits on the list stream too', () async {
      await repository.loadProjects();

      final emissions = <List<Project>>[];
      final sub = repository.projects.listen(emissions.add);
      addTearDown(sub.cancel);

      await repository.updateProjectName('sun', 'Sun Shine v2');
      await Future<void>.delayed(Duration.zero);

      expect(emissions.last.first.name, 'Sun Shine v2');
    });

    test('rejects an empty name', () async {
      await repository.loadProjects();

      final result = await repository.updateProjectName('sun', '   ');

      expect(result, isA<Error<Project>>());
      expect(
        (result as Error<Project>).error,
        isA<InvalidProjectNameException>(),
      );
    });

    test('invalidateCache empties the store and allows a refetch', () async {
      await repository.loadProjects();
      expect(localService.value, hasLength(3));

      repository.invalidateCache();
      expect(localService.value, isEmpty);

      await repository.loadProjects();
      expect(localService.value, hasLength(3));
    });
  });
}
