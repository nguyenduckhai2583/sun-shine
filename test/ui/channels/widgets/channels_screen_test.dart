import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/pump_app.dart';

void main() {
  group('ChannelsScreen', () {
    testWidgets('renders every channel with its topic and member count', (
      tester,
    ) async {
      await pumpApp(tester);

      expect(find.byType(ListTile), findsNWidgets(4));
      expect(find.text('#general'), findsOneWidget);
      expect(find.text('#random'), findsOneWidget);
      expect(find.text('Company-wide announcements'), findsOneWidget);
      expect(find.text('128'), findsOneWidget);
    });

    testWidgets('tapping a row opens that channel', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.widgetWithText(ListTile, '#design'));
      await tester.pumpAndSettle();

      expect(find.byType(ChannelDetailScreen), findsOneWidget);
      expect(find.text('Specs, critique, design system'), findsOneWidget);
      expect(find.text('17 members'), findsOneWidget);
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
