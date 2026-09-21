import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/fakes/fake_auth_api_client.dart';
import '../../../testing/fakes/fake_session_repository.dart';
import '../../../testing/fakes/fake_token_refresh_api_client.dart';
import '../../../testing/fakes/fake_workspace_repository.dart';
import '../../../testing/pump_app.dart';

void main() {
  group('HomeViewModel', () {
    late FakeSessionRepository sessions;
    late FakeWorkspaceRepository workspaces;
    late FakeTokenRefreshApiClient tokenRefresh;
    late AuthManager authManager;

    setUp(() {
      sessions = FakeSessionRepository();
      workspaces = FakeWorkspaceRepository();
      tokenRefresh = FakeTokenRefreshApiClient();
      authManager = AuthManager(
        baseUrl: 'https://test.invalid/',
        apiClient: FakeAuthApiClient(),
      );
      addTearDown(sessions.dispose);
      addTearDown(workspaces.dispose);
      addTearDown(authManager.dispose);
    });

    HomeViewModel buildViewModel() {
      final switchAccount = SwitchAccountUseCase(
        sessionRepository: sessions,
        workspaceRepository: workspaces,
        tokenRefreshApiClient: tokenRefresh,
      );
      final viewModel = HomeViewModel(
        watchAccountsUseCase: WatchAccountsUseCase(
          sessionRepository: sessions,
          workspaceRepository: workspaces,
        ),
        selectWorkspaceUseCase: SelectWorkspaceUseCase(
          sessionRepository: sessions,
          switchAccountUseCase: switchAccount,
        ),
        refreshAccountWorkspacesUseCase: RefreshAccountWorkspacesUseCase(
          sessionRepository: sessions,
          workspaceRepository: workspaces,
        ),
        signOutUseCase: SignOutUseCase(
          sessionRepository: sessions,
          workspaceRepository: workspaces,
        ),
        signInFlowUseCase: SignInFlowUseCase(authManager: authManager),
      );
      addTearDown(viewModel.dispose);
      return viewModel;
    }

    test('loads the active account workspaces on construction', () async {
      sessions.emit(fakeSession(workspaceId: 'ws_1'));

      final viewModel = buildViewModel();
      await viewModel.load.execute();
      await pumpEventQueue();

      expect(viewModel.load.completed, isTrue);
      expect(viewModel.workspaces, FakeWorkspaceRepository.defaultWorkspaces);
      expect(viewModel.selectedWorkspace?.id, 'ws_1');
    });

    test('exposes the failure through the load command', () async {
      sessions.emit(fakeSession());
      workspaces.failure = Exception('boom');

      final viewModel = buildViewModel();
      await viewModel.load.execute();
      await pumpEventQueue();

      expect(viewModel.load.error, isTrue);
      expect(viewModel.workspaces, isEmpty);
    });

    test('groups every signed-in account', () async {
      sessions.emitAll([
        fakeSession(),
        fakeSession(userId: 'u2', email: 'luc@sunshine.com'),
      ], activeUserId: 'u1');

      final viewModel = buildViewModel();
      await pumpEventQueue();

      expect(viewModel.accounts.map((account) => account.session.userId), [
        'u1',
        'u2',
      ]);
      expect(viewModel.hasMultipleAccounts, isTrue);
      expect(viewModel.activeUserId, 'u1');
      expect(viewModel.accounts.first.isActive, isTrue);
      expect(viewModel.accounts.last.isActive, isFalse);
      expect(viewModel.accounts.last.workspaces, isNotEmpty);
    });

    test('selecting a workspace of the active account assigns it', () async {
      sessions.emit(fakeSession(workspaceId: 'ws_1'));

      final viewModel = buildViewModel();
      await viewModel.load.execute();
      await pumpEventQueue();

      await viewModel.selectWorkspace.execute((
        accountUserId: 'u1',
        workspaceId: 'ws_2',
      ));
      await pumpEventQueue();

      expect(viewModel.selectedWorkspace?.name, 'Design Team');
      expect(sessions.currentSession?.workspaceId, 'ws_2');
    });

    test('selecting another account workspace switches the account', () async {
      sessions.emitAll([
        fakeSession(),
        fakeSession(userId: 'u2', email: 'luc@sunshine.com'),
      ], activeUserId: 'u1');
      workspaces.seed('u2', const [Workspace(id: 'ws_9', name: 'Other Co')]);

      final viewModel = buildViewModel();
      await pumpEventQueue();

      await viewModel.selectWorkspace.execute((
        accountUserId: 'u2',
        workspaceId: 'ws_9',
      ));
      await pumpEventQueue();

      expect(sessions.currentSession?.userId, 'u2');
      expect(sessions.currentSession?.workspaceId, 'ws_9');
      expect(viewModel.activeUserId, 'u2');
    });

    test('signing out the active account promotes the next one', () async {
      sessions.emitAll([
        fakeSession(),
        fakeSession(userId: 'u2', email: 'luc@sunshine.com'),
      ], activeUserId: 'u1');

      final viewModel = buildViewModel();
      await pumpEventQueue();

      await viewModel.signOutActive();
      await pumpEventQueue();

      expect(sessions.currentSession?.userId, 'u2');
      expect(workspaces.removedAccounts, ['u1']);
      expect(viewModel.hasMultipleAccounts, isFalse);
    });

    test('signing out of everything clears the cache too', () async {
      sessions.emitAll([
        fakeSession(),
        fakeSession(userId: 'u2', email: 'luc@sunshine.com'),
      ], activeUserId: 'u1');

      final viewModel = buildViewModel();
      await pumpEventQueue();

      await viewModel.signOutAll();
      await pumpEventQueue();

      expect(sessions.currentSession, isNull);
      expect(workspaces.clearCount, 1);
      expect(viewModel.accounts, isEmpty);
    });

    test('addAccount puts the sign-in flow into add-account mode', () async {
      sessions.emit(fakeSession());

      final viewModel = buildViewModel();
      viewModel.addAccount();
      await pumpEventQueue();

      expect(authManager.isAddingAccount, isTrue);
    });

    test('accounts getter is unmodifiable', () async {
      sessions.emit(fakeSession());

      final viewModel = buildViewModel();
      await pumpEventQueue();

      expect(
        () => viewModel.accounts.add(viewModel.accounts.first),
        throwsUnsupportedError,
      );
    });
  });
}
