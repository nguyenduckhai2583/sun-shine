import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../testing/fakes/fake_workspace_api_client.dart';

void main() {
  group('WorkspaceRepositoryRemote', () {
    late FakeWorkspaceApiClient apiClient;
    late WorkspaceRepositoryRemote repository;
    setUp(() {
      apiClient = FakeWorkspaceApiClient();
      repository = WorkspaceRepositoryRemote(apiClient: apiClient);
    });
    test('maps api models onto domain models', () async {
      final result = await repository.getWorkspaces();
      expect(result, isA<Ok<List<Workspace>>>());
      final workspaces = (result as Ok<List<Workspace>>).value;
      expect(workspaces, [
        const Workspace(id: 'ws_1', name: 'Sun Shine', unreadCount: 3),
        const Workspace(id: 'ws_2', name: 'Design Team'),
      ]);
    });
    test('propagates a service failure', () async {
      apiClient.failure = Exception('offline');
      final result = await repository.getWorkspaces();
      expect(result, isA<Error<List<Workspace>>>());
    });
    test(
      'serves the second read from cache without hitting the service',
      () async {
        await repository.getWorkspaces();
        await repository.getWorkspaces();
        expect(apiClient.getWorkspacesCallCount, 1);
      },
    );
    test('does not cache a failed read', () async {
      apiClient.failure = Exception('offline');
      await repository.getWorkspaces();
      apiClient.failure = null;
      final result = await repository.getWorkspaces();
      expect(result, isA<Ok<List<Workspace>>>());
      expect(apiClient.getWorkspacesCallCount, 2);
    });
    test('invalidateCache forces a refetch', () async {
      await repository.getWorkspaces();
      repository.invalidateCache();
      await repository.getWorkspaces();
      expect(apiClient.getWorkspacesCallCount, 2);
    });
  });
}
