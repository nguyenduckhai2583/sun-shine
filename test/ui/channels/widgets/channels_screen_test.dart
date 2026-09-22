import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/pump_app.dart';

void main() {
  group('ChannelsScreen', () {
    testWidgets('renders every channel the workspace has', (tester) async {
      await pumpApp(tester);

      expect(find.byType(ListTile), findsNWidgets(4));
      expect(find.text('#general'), findsOneWidget);
      expect(find.text('#random'), findsOneWidget);
    });

    testWidgets('a private channel is marked with a lock', (tester) async {
      await pumpApp(tester);

      expect(
        find.descendant(
          of: find.widgetWithText(ListTile, '#engineering'),
          matching: find.byIcon(Icons.lock),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.widgetWithText(ListTile, '#general'),
          matching: find.byIcon(Icons.tag),
        ),
        findsOneWidget,
      );
    });

    testWidgets('an encrypted channel carries a shield', (tester) async {
      await pumpApp(tester);

      expect(
        find.descendant(
          of: find.widgetWithText(ListTile, '#design'),
          matching: find.byIcon(Icons.shield_outlined),
        ),
        findsOneWidget,
      );
    });

    testWidgets('tapping a row opens that channel', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.widgetWithText(ListTile, '#design'));
      await tester.pumpAndSettle();

      expect(find.byType(ChannelDetailScreen), findsOneWidget);
      expect(find.text('#design'), findsWidgets);
    });

    testWidgets('keeps its scroll state across a tab round trip', (
      tester,
    ) async {
      await pumpApp(tester);

      await tester.tap(find.widgetWithText(NavigationDestination, 'More'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(NavigationDestination, 'Channels'));
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(4));
    });
  });
}
