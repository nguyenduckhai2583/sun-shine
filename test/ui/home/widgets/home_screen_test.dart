import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/pump_app.dart';

void main() {
  group('HomeScreen shell', () {
    testWidgets('starts on the Channels branch', (tester) async {
      await pumpApp(tester);

      expect(find.byType(ChannelsScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('switching branches swaps the body', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.widgetWithText(NavigationDestination, 'More'));
      await tester.pumpAndSettle();

      expect(find.byType(MoreScreen), findsOneWidget);
      expect(find.byType(ChannelsScreen), findsNothing);
    });

    testWidgets('deep linking straight to a branch works', (tester) async {
      await pumpApp(tester, initialLocation: Routes.dms);

      expect(find.text('Direct message list goes here.'), findsOneWidget);
    });

    testWidgets('unknown location renders the error screen', (tester) async {
      await pumpApp(tester, initialLocation: '/nope');

      expect(find.text('Page not found'), findsOneWidget);
    });

    testWidgets('the drawer is reachable from a tab', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      expect(find.byType(HomeDrawer), findsOneWidget);
      expect(find.text('Your workspaces'), findsOneWidget);
    });

    testWidgets('app bar title follows the selected workspace', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Design Team'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Design Team'), findsOneWidget);
    });

    testWidgets('pushing the detail route covers the tab bar', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.widgetWithText(ListTile, '#general'));
      await tester.pumpAndSettle();

      expect(find.text('#general'), findsWidgets);
      expect(find.byType(NavigationBar), findsNothing);
    });
  });

  group('nested navigation in the More tab', () {
    Future<void> openSettings(WidgetTester tester) async {
      await tester.tap(find.widgetWithText(NavigationDestination, 'More'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ListTile, 'Settings'));
      await tester.pumpAndSettle();
    }

    testWidgets('keeps the tab bar and swaps in its own app bar', (
      tester,
    ) async {
      await pumpApp(tester);
      await openSettings(tester);

      expect(find.byType(MoreSettingsScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);
      expect(
        find.byTooltip('Open navigation menu'),
        findsNothing,
        reason: 'a drilled-down page shows back, not the drawer menu',
      );
    });

    testWidgets('survives a round trip to another tab', (tester) async {
      await pumpApp(tester);
      await openSettings(tester);

      await tester.tap(find.widgetWithText(NavigationDestination, 'Channels'));
      await tester.pumpAndSettle();
      expect(find.byType(ChannelsScreen), findsOneWidget);

      await tester.tap(find.widgetWithText(NavigationDestination, 'More'));
      await tester.pumpAndSettle();

      expect(
        find.byType(MoreSettingsScreen),
        findsOneWidget,
        reason: 'the More branch keeps its own back stack',
      );
    });

    testWidgets('back pops within the tab, not out of the app', (tester) async {
      await pumpApp(tester);
      await openSettings(tester);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byType(MoreSettingsScreen), findsNothing);
      expect(find.byType(MoreScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('deep linking straight to the nested route works', (
      tester,
    ) async {
      await pumpApp(tester, initialLocation: Routes.moreSettings);

      expect(find.byType(MoreSettingsScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
    });
  });
}
