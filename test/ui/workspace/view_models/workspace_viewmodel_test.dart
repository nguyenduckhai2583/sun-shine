import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/fakes/fake_session_repository.dart';
import '../../../testing/fakes/fake_token_refresh_api_client.dart';
import '../../../testing/fakes/fake_workspace_repository.dart';
import '../../../testing/pump_app.dart';

void main() {
  group('WorkspaceViewModel', () {
    late FakeSessionRepository sessions;
    late FakeWorkspaceRepository workspaces;

    setUp(() {
      sessions = FakeSessionRepository();
      workspaces = FakeWorkspaceRepository();
      addTearDown(sessions.dispose);
      addTearDown(workspaces.dispose);
    });

    WorkspaceViewModel buildViewModel() {
      final viewModel = WorkspaceViewModel(
        watchAccountsUseCase: WatchAccountsUseCase(
          sessionRepository: sessions,
          workspaceRepository: workspaces,
        ),
        refreshAccountWorkspacesUseCase: RefreshAccountWorkspacesUseCase(
          sessionRepository: sessions,
          workspaceRepository: workspaces,
        ),
        selectWorkspaceUseCase: SelectWorkspaceUseCase(
          sessionRepository: sessions,
          switchAccountUseCase: SwitchAccountUseCase(
            sessionRepository: sessions,
            workspaceRepository: workspaces,
            tokenRefreshApiClient: FakeTokenRefreshApiClient(),
          ),
        ),
        signOutUseCase: SignOutUseCase(
          sessionRepository: sessions,
          workspaceRepository: workspaces,
        ),
      );
      addTearDown(viewModel.dispose);
      return viewModel;
    }

    test('loads the workspaces of the account being onboarded', () async {
      sessions.emit(fakeSession(workspaceId: null));

      final viewModel = buildViewModel();
      await viewModel.load.execute();
      await pumpEventQueue();

      expect(viewModel.workspaces, FakeWorkspaceRepository.defaultWorkspaces);
      expect(viewModel.accountUserId, 'u1');
      expect(viewModel.isEmpty, isFalse);
    });

    test('nothing is picked until the user picks', () async {
      sessions.emit(fakeSession(workspaceId: null));

      final viewModel = buildViewModel();
      await viewModel.load.execute();
      await pumpEventQueue();

      expect(viewModel.selectedWorkspaceId, isNull);
      expect(viewModel.canSubmit, isFalse);
    });

    test('an account already in a workspace comes back to it', () async {
      sessions.emit(fakeSession(workspaceId: 'ws_2'));

      final viewModel = buildViewModel();
      await viewModel.load.execute();
      await pumpEventQueue();

      expect(viewModel.selectedWorkspaceId, 'ws_2');
      expect(viewModel.canSubmit, isTrue);
    });

    test('picking one notifies and enables submitting', () async {
      sessions.emit(fakeSession(workspaceId: null));

      final viewModel = buildViewModel();
      await viewModel.load.execute();
      await pumpEventQueue();

      var notifications = 0;
      viewModel.addListener(() => notifications++);
      viewModel.select('ws_1');

      expect(viewModel.selectedWorkspace?.name, 'Sun Shine');
      expect(viewModel.canSubmit, isTrue);
      expect(notifications, 1);
    });

    test('picking the same one again changes nothing', () async {
      sessions.emit(fakeSession(workspaceId: 'ws_1'));

      final viewModel = buildViewModel();
      await pumpEventQueue();

      var notifications = 0;
      viewModel.addListener(() => notifications++);
      viewModel.select('ws_1');

      expect(notifications, 0);
    });

    test('submitting assigns the workspace to the session', () async {
      sessions.emit(fakeSession(workspaceId: null));

      final viewModel = buildViewModel();
      await viewModel.load.execute();
      await pumpEventQueue();

      viewModel.select('ws_2');
      await viewModel.submit.execute();

      expect(viewModel.submit.completed, isTrue);
      expect(sessions.currentSession?.workspaceId, 'ws_2');
    });

    test('submitting without a pick is refused', () async {
      sessions.emit(fakeSession(workspaceId: null));

      final viewModel = buildViewModel();
      await viewModel.load.execute();
      await pumpEventQueue();

      await viewModel.submit.execute();

      expect(viewModel.submit.error, isTrue);
      expect(sessions.currentSession?.workspaceId, isNull);
    });

    test('an account with no workspaces reports itself empty', () async {
      sessions.emit(fakeSession(workspaceId: null));
      workspaces.workspaces = const [];

      final viewModel = buildViewModel();
      await viewModel.load.execute();
      await pumpEventQueue();

      expect(viewModel.isEmpty, isTrue);
      expect(viewModel.canSubmit, isFalse);
    });

    test('the load failure is surfaced through the command', () async {
      sessions.emit(fakeSession(workspaceId: null));
      workspaces.failure = Exception('offline');

      final viewModel = buildViewModel();
      await viewModel.load.execute();
      await pumpEventQueue();

      expect(viewModel.load.error, isTrue);
    });

    test('signing out drops the account', () async {
      sessions.emit(fakeSession(workspaceId: null));

      final viewModel = buildViewModel();
      await pumpEventQueue();

      await viewModel.signOut();

      expect(sessions.currentSession, isNull);
    });
  });
}
