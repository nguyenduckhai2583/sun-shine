import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/fakes/fake_workspace_repository.dart';

void main() {
  late FakeWorkspaceRepository repository;

  setUp(() => repository = FakeWorkspaceRepository());

  Future<HomeViewModel> pumpDrawer(WidgetTester tester) async {
    final viewModel = HomeViewModel(workspaceRepository: repository);
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

  group('HomeDrawer', () {
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

      expect(viewModel.selectedWorkspace?.id, 'ws_2');
    });

    testWidgets('shows a retry affordance when loading fails', (tester) async {
      repository.failure = Exception('offline');
      await pumpDrawer(tester);

      expect(find.text('Could not load workspaces'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Retry'), findsOneWidget);
    });

    testWidgets('retry re-runs the load', (tester) async {
      repository.failure = Exception('offline');
      await pumpDrawer(tester);

      repository.failure = null;
      await tester.tap(find.widgetWithText(TextButton, 'Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Sun Shine'), findsOneWidget);
    });

    testWidgets('shows an empty state when there are no workspaces', (
      tester,
    ) async {
      repository.workspaces = const [];
      await pumpDrawer(tester);

      expect(find.text('No workspaces yet'), findsOneWidget);
    });
  });
}
