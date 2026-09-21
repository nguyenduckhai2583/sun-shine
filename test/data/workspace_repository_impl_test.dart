import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../testing/fakes/fake_workspace_api_client.dart';

void main() {
  group('WorkspaceRepositoryImpl', () {
    late FakeWorkspaceApiClient apiClient;
    late WorkspaceLocalService localService;
    late WorkspaceRepositoryImpl repository;

    setUp(() {
      apiClient = FakeWorkspaceApiClient();
      localService = WorkspaceLocalService();
      repository = WorkspaceRepositoryImpl(
        apiClient: apiClient,
        localService: localService,
      );
      addTearDown(localService.dispose);
    });

    test('maps api models onto domain models and caches them', () async {
      final result = await repository.refresh('u1');

      expect(result, isA<Ok<List<Workspace>>>());
      expect((result as Ok<List<Workspace>>).value, [
        const Workspace(id: 'ws_1', name: 'Sun Shine'),
        const Workspace(id: 'ws_2', name: 'Design Team'),
      ]);
      expect(repository.workspacesOf('u1'), hasLength(2));
    });

    test('caches each account separately', () async {
      await repository.refresh('u1');
      apiClient.workspaces = const [
        WorkspaceApiModel(id: 'ws_9', name: 'Other Co'),
      ];
      await repository.refresh('u2', token: 'tok_u2');

      expect(repository.workspacesOf('u1'), hasLength(2));
      expect(repository.workspacesOf('u2'), [
        const Workspace(id: 'ws_9', name: 'Other Co'),
      ]);
    });

    test('a token refreshes a background account', () async {
      await repository.refresh('u2', token: 'tok_u2');

      expect(apiClient.authorizations, ['Bearer tok_u2']);
    });

    test('propagates a service failure and keeps the cache', () async {
      await repository.refresh('u1');
      apiClient.failure = Exception('offline');

      final result = await repository.refresh('u1');

      expect(result, isA<Error<List<Workspace>>>());
      expect(repository.workspacesOf('u1'), hasLength(2));
    });

    test('removeAccount drops only that account', () async {
      await repository.refresh('u1');
      await repository.refresh('u2', token: 'tok_u2');

      await repository.removeAccount('u1');

      expect(repository.workspacesOf('u1'), isEmpty);
      expect(repository.workspacesOf('u2'), hasLength(2));
    });

    test('watchWorkspacesOf emits the account cache', () async {
      expectLater(
        repository.watchWorkspacesOf('u1'),
        emitsInOrder([isEmpty, hasLength(2)]),
      );

      await repository.refresh('u1');
    });

    test('pruneExcept drops accounts that are gone', () async {
      await repository.refresh('u1');
      await repository.refresh('u2', token: 'tok_u2');

      await repository.pruneExcept({'u2'});

      expect(repository.workspacesOf('u1'), isEmpty);
      expect(repository.workspacesOf('u2'), hasLength(2));
    });

    test('pruneExcept leaves a cache that is still wanted alone', () async {
      await repository.refresh('u1');

      await repository.pruneExcept({'u1'});

      expect(repository.workspacesOf('u1'), hasLength(2));
    });

    test('clear empties every account', () async {
      await repository.refresh('u1');

      await repository.clear();

      expect(repository.workspacesOf('u1'), isEmpty);
    });
  });
}
