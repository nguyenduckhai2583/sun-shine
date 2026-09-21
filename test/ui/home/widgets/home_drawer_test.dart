import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/fakes/fake_auth_api_client.dart';
import '../../../testing/fakes/fake_session_repository.dart';
import '../../../testing/fakes/fake_token_refresh_api_client.dart';
import '../../../testing/fakes/fake_workspace_repository.dart';
import '../../../testing/pump_app.dart';

void main() {
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

  Future<HomeViewModel> pumpDrawer(WidgetTester tester) async {
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

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<HomeViewModel>.value(
          value: viewModel,
          child: const Scaffold(drawer: HomeDrawer()),
        ),
      ),
    );
    tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();
    return viewModel;
  }

  group('HomeDrawer with one account', () {
    setUp(() => sessions.emit(fakeSession(workspaceId: 'ws_1')));

    testWidgets('lists the workspaces', (tester) async {
      await pumpDrawer(tester);

      expect(find.text('Your workspaces'), findsOneWidget);
      expect(find.text('Sun Shine'), findsOneWidget);
      expect(find.text('Design Team'), findsOneWidget);
    });

    testWidgets('renders the unread badge', (tester) async {
      await pumpDrawer(tester);

      expect(find.widgetWithText(Badge, '3'), findsOneWidget);
    });

    testWidgets('tapping a workspace selects it', (tester) async {
      final viewModel = await pumpDrawer(tester);

      await tester.tap(find.text('Design Team'));
      await tester.pumpAndSettle();

      expect(viewModel.selectedWorkspaceId, 'ws_2');
    });

    testWidgets('shows a retry affordance when loading fails', (tester) async {
      workspaces.failure = Exception('offline');
      await pumpDrawer(tester);

      expect(find.text('Could not load workspaces'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Retry'), findsOneWidget);
    });

    testWidgets('retry re-runs the load', (tester) async {
      workspaces.failure = Exception('offline');
      await pumpDrawer(tester);

      workspaces.failure = null;
      await tester.tap(find.widgetWithText(TextButton, 'Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Sun Shine'), findsOneWidget);
    });

    testWidgets('shows an empty state when there are no workspaces', (
      tester,
    ) async {
      workspaces.workspaces = const [];
      await pumpDrawer(tester);

      expect(find.text('No workspaces yet'), findsOneWidget);
    });

    testWidgets('hides the sign out all entry', (tester) async {
      await pumpDrawer(tester);

      expect(find.text('Sign out of all accounts'), findsNothing);
    });

    testWidgets('add another account enters add-account mode', (tester) async {
      await pumpDrawer(tester);

      await tester.tap(find.text('Add another account'));
      await tester.pumpAndSettle();

      expect(authManager.isAddingAccount, isTrue);
    });
  });

  group('HomeDrawer with several accounts', () {
    setUp(() {
      sessions.emitAll([
        fakeSession(workspaceId: 'ws_1'),
        fakeSession(
          userId: 'u2',
          email: 'luc@sunshine.com',
          workspaceId: 'ws_1',
        ),
      ], activeUserId: 'u1');
    });

    testWidgets('groups the workspaces under each account', (tester) async {
      await pumpDrawer(tester);

      expect(find.text('khai@sunshine.com'), findsOneWidget);
      expect(find.text('luc@sunshine.com'), findsOneWidget);
      expect(find.text('Sun Shine'), findsNWidgets(2));
    });

    testWidgets('collapsing an account hides its workspaces', (tester) async {
      await pumpDrawer(tester);

      await tester.tap(find.text('luc@sunshine.com'));
      await tester.pumpAndSettle();

      expect(find.text('Sun Shine'), findsOneWidget);
    });

    testWidgets('tapping another account workspace switches account', (
      tester,
    ) async {
      final viewModel = await pumpDrawer(tester);

      await tester.tap(find.text('Design Team').last);
      await tester.pumpAndSettle();

      expect(viewModel.activeUserId, 'u2');
      expect(sessions.currentSession?.workspaceId, 'ws_2');
    });

    testWidgets('a dead session drops the account and warns', (tester) async {
      sessions.emitAll([
        fakeSession(workspaceId: 'ws_1'),
        fakeSession(
          userId: 'u2',
          email: 'luc@sunshine.com',
          workspaceId: 'ws_1',
          refreshToken: 'stale',
          expireAt: 1,
        ),
      ], activeUserId: 'u1');
      tokenRefresh.failure = Exception('revoked');

      final viewModel = await pumpDrawer(tester);

      await tester.tap(find.text('Design Team').last);
      await tester.pumpAndSettle();

      expect(viewModel.activeUserId, 'u1');
      expect(sessions.removed, ['u2']);
      expect(find.text(HomeDrawer.switchFailedMessage), findsOneWidget);
    });

    testWidgets('sign out switches to the remaining account', (tester) async {
      final viewModel = await pumpDrawer(tester);

      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();

      expect(viewModel.activeUserId, 'u2');
    });

    testWidgets('sign out of all accounts clears everything', (tester) async {
      final viewModel = await pumpDrawer(tester);

      await tester.tap(find.text('Sign out of all accounts'));
      await tester.pumpAndSettle();

      expect(viewModel.accounts, isEmpty);
      expect(workspaces.clearCount, 1);
    });
  });
}
