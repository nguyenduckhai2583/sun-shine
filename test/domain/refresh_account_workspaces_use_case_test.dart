import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../testing/fakes/fake_session_repository.dart';
import '../testing/fakes/fake_workspace_repository.dart';

void main() {
  group('RefreshAccountWorkspacesUseCase', () {
    const khai = Session(userId: 'u1', token: 't1', workspaceId: 'w1');
    const linh = Session(userId: 'u2', token: 't2', workspaceId: 'w9');

    late FakeSessionRepository sessions;
    late FakeWorkspaceRepository workspaces;
    late RefreshAccountWorkspacesUseCase useCase;

    setUp(() {
      sessions = FakeSessionRepository();
      workspaces = FakeWorkspaceRepository();
      useCase = RefreshAccountWorkspacesUseCase(
        sessionRepository: sessions,
        workspaceRepository: workspaces,
      );
      addTearDown(sessions.dispose);
      addTearDown(workspaces.dispose);
    });

    test('loads the cache before going to the network', () async {
      await useCase.execute();

      expect(workspaces.restoreCount, 1);
    });

    test('prunes the cache of accounts that are no longer signed in', () async {
      sessions.emitAll([khai, linh], activeUserId: 'u1');
      workspaces.seed('u3', const [Workspace(id: 'ws_x', name: 'Gone Co')]);

      await useCase.execute();

      expect(workspaces.pruneCalls.single, {'u1', 'u2'});
      expect(workspaces.workspacesOf('u3'), isEmpty);
    });

    test('refreshes the active account on the shared client', () async {
      sessions.emit(khai);

      await useCase.execute();

      expect(workspaces.refreshedAccounts, ['u1']);
      expect(workspaces.refreshedTokens, [null]);
    });

    test('refreshes background accounts with their own token', () async {
      sessions.emitAll([khai, linh], activeUserId: 'u1');

      await useCase.execute();

      expect(workspaces.refreshedAccounts, containsAll(['u1', 'u2']));
      expect(workspaces.refreshedTokens, contains('t2'));
    });

    test('a failed background refresh costs nobody their account', () async {
      sessions.emitAll([khai, linh], activeUserId: 'u1');
      workspaces.failure = Exception('offline');

      await useCase.execute();

      expect(sessions.allSessions, hasLength(2));
      expect(workspaces.removedAccounts, isEmpty);
    });

    test('reports the active account failure to the caller', () async {
      sessions.emit(khai);
      workspaces.failure = Exception('offline');

      final result = await useCase.execute();

      expect(result, isA<Error<List<Workspace>>>());
    });

    test('signed out, there is nothing to report', () async {
      final result = await useCase.execute();

      expect(result, isA<Ok<List<Workspace>>>());
      expect(workspaces.refreshCallCount, 0);
    });
  });
}
