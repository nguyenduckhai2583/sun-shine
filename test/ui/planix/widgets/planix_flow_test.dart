import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/pump_app.dart';

void main() {
  Future<void> openPlanix(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(NavigationDestination, 'More'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Planix'));
    await tester.pumpAndSettle();
  }

  ProjectLocalService serviceOf(WidgetTester tester, Finder anchor) =>
      tester.element(anchor).read<ProjectLocalService>();

  group('planix module', () {
    testWidgets('opens full screen from the More tab', (tester) async {
      await pumpApp(tester);
      await openPlanix(tester);

      expect(find.byType(PlanixProjectsScreen), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Planix'), findsOneWidget);
      expect(
        find.byType(NavigationBar),
        findsNothing,
        reason: 'planix is a full page, it covers the home shell',
      );
    });

    testWidgets('lists projects', (tester) async {
      await pumpApp(tester);
      await openPlanix(tester);

      expect(find.byType(ListTile), findsNWidgets(3));
      expect(find.text('Sun Shine'), findsOneWidget);
      expect(find.text('Hplix Platform'), findsOneWidget);
      expect(find.text('47 open tasks'), findsOneWidget);
    });

    testWidgets('opens a project detail', (tester) async {
      await pumpApp(tester);
      await openPlanix(tester);

      await tester.tap(find.widgetWithText(ListTile, 'Mobile Revamp'));
      await tester.pumpAndSettle();

      expect(find.byType(PlanixProjectDetailScreen), findsOneWidget);
      expect(find.text('MOB'), findsOneWidget);
      expect(find.text('5 open tasks'), findsOneWidget);
    });

    testWidgets('list and detail share one module scope', (tester) async {
      await pumpApp(tester);
      await openPlanix(tester);

      final fromList = serviceOf(
        tester,
        find.widgetWithText(ListTile, 'Sun Shine'),
      );

      await tester.tap(find.widgetWithText(ListTile, 'Sun Shine'));
      await tester.pumpAndSettle();

      final fromDetail = serviceOf(tester, find.text('12 open tasks'));

      expect(identical(fromList, fromDetail), isTrue);
    });

    testWidgets('renaming a project updates the list instantly', (
      tester,
    ) async {
      await pumpApp(tester);
      await openPlanix(tester);

      final listViewModel = tester
          .element(find.widgetWithText(ListTile, 'Sun Shine'))
          .read<PlanixProjectsViewModel>();

      await tester.tap(find.widgetWithText(ListTile, 'Sun Shine'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Rename project'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Sun Shine v2');
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      expect(
        listViewModel.projects.firstWhere((p) => p.id == 'sun').name,
        'Sun Shine v2',
        reason: 'both screens read the same ProjectLocalService',
      );

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.widgetWithText(ListTile, 'Sun Shine v2'), findsOneWidget);
    });
  });

  group('back navigation', () {
    testWidgets('the module entry page has an automatic back button', (
      tester,
    ) async {
      await pumpApp(tester);
      await openPlanix(tester);

      expect(find.widgetWithText(AppBar, 'Planix'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(BackButton),
        ),
        findsOneWidget,
        reason: 'first page of the module shell, so it wires its own leading',
      );

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(MoreScreen), findsOneWidget);
    });

    testWidgets('the detail page has an automatic back button', (tester) async {
      await pumpApp(tester);
      await openPlanix(tester);
      await tester.tap(find.widgetWithText(ListTile, 'Sun Shine'));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(BackButton),
        ),
        findsOneWidget,
      );

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(PlanixProjectsScreen), findsOneWidget);
    });
  });

  group('planix module lifetime', () {
    testWidgets('leaving the module disposes its scope', (tester) async {
      await pumpApp(tester);
      await openPlanix(tester);

      final service = serviceOf(
        tester,
        find.widgetWithText(ListTile, 'Sun Shine'),
      );
      expect(service.value, hasLength(3));
      expect(service.isDisposed, isFalse);

      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.byType(MoreScreen), findsOneWidget);
      expect(
        service.isDisposed,
        isTrue,
        reason: 'popping the module unmounted its shell scope',
      );
    });

    testWidgets('going list -> detail keeps the data', (tester) async {
      await pumpApp(tester);
      await openPlanix(tester);

      final service = serviceOf(
        tester,
        find.widgetWithText(ListTile, 'Sun Shine'),
      );

      await tester.tap(find.widgetWithText(ListTile, 'Sun Shine'));
      await tester.pumpAndSettle();

      expect(
        service.value,
        hasLength(3),
        reason: 'still inside the module, only a route deeper',
      );

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(service.value, hasLength(3));
    });

    testWidgets('reopening the module builds a fresh scope', (tester) async {
      await pumpApp(tester);
      await openPlanix(tester);

      final first = serviceOf(
        tester,
        find.widgetWithText(ListTile, 'Sun Shine'),
      );

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(first.isDisposed, isTrue);

      await tester.tap(find.widgetWithText(ListTile, 'Planix'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, 'Sun Shine'), findsOneWidget);

      final second = serviceOf(
        tester,
        find.widgetWithText(ListTile, 'Sun Shine'),
      );
      expect(
        identical(first, second),
        isFalse,
        reason: 'a new scope, not the disposed one',
      );
      expect(
        second.value,
        hasLength(3),
        reason: 'the fresh repository refetched from the api',
      );
    });
  });
}
