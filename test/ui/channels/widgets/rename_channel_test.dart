import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/pump_app.dart';

void main() {
  Future<void> openDetail(WidgetTester tester, String name) async {
    await tester.tap(find.widgetWithText(ListTile, name));
    await tester.pumpAndSettle();
  }

  Future<void> rename(WidgetTester tester, String newName) async {
    await tester.tap(find.byTooltip('Rename channel'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), newName);
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
  }

  group('renaming a channel', () {
    testWidgets('updates the detail screen', (tester) async {
      await pumpApp(tester);
      await openDetail(tester, '#general');

      await rename(tester, 'announcements');

      expect(find.widgetWithText(AppBar, '#announcements'), findsOneWidget);
      expect(find.text('#announcements'), findsWidgets);
    });

    testWidgets('the list updates without any refresh on the way back', (
      tester,
    ) async {
      await pumpApp(tester);
      expect(find.widgetWithText(ListTile, '#general'), findsOneWidget);

      await openDetail(tester, '#general');
      await rename(tester, 'announcements');

      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, '#announcements'), findsOneWidget);
      expect(find.widgetWithText(ListTile, '#general'), findsNothing);
    });

    testWidgets('the list view model sees the change while still on detail', (
      tester,
    ) async {
      await pumpApp(tester);

      final listViewModel = tester
          .element(find.widgetWithText(ListTile, '#general'))
          .read<ChannelsViewModel>();

      await openDetail(tester, '#general');
      await rename(tester, 'announcements');

      expect(
        listViewModel.channels.firstWhere((c) => c.id == 'general').name,
        'announcements',
        reason: 'the list model updated from the stream, not from a pop result',
      );
    });

    testWidgets('cancelling leaves the name alone', (tester) async {
      await pumpApp(tester);
      await openDetail(tester, '#design');

      await tester.tap(find.byTooltip('Rename channel'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'ux');
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, '#design'), findsOneWidget);
    });

    testWidgets('rejects an empty name', (tester) async {
      await pumpApp(tester);
      await openDetail(tester, '#design');

      await tester.tap(find.byTooltip('Rename channel'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), '   ');
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      expect(find.text('Name cannot be empty'), findsOneWidget);
      expect(find.byType(RenameDialog), findsOneWidget);
    });

    testWidgets('rejects a name with spaces', (tester) async {
      await pumpApp(tester);
      await openDetail(tester, '#design');

      await tester.tap(find.byTooltip('Rename channel'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'design team');
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      expect(find.text('Name cannot contain spaces'), findsOneWidget);
    });
  });
}
