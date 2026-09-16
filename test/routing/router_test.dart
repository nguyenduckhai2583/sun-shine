import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../testing/pump_app.dart';

void main() {
  ModalRoute<dynamic>? routeOf(WidgetTester tester, Finder screen) =>
      ModalRoute.of(tester.element(screen));

  group('page transitions', () {
    testWidgets('a root push animates', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.widgetWithText(ListTile, '#general'));
      await tester.pumpAndSettle();

      final route = routeOf(tester, find.byType(ChannelDetailScreen));
      expect(route, isA<MaterialRouteTransitionMixin<dynamic>>());
      expect(route!.transitionDuration, greaterThan(Duration.zero));
    });

    testWidgets('a nested push animates', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.widgetWithText(NavigationDestination, 'More'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Settings (nested demo)'));
      await tester.pumpAndSettle();

      final route = routeOf(tester, find.byType(MoreSettingsScreen));
      expect(route, isA<MaterialRouteTransitionMixin<dynamic>>());
      expect(route!.transitionDuration, greaterThan(Duration.zero));
    });

    testWidgets('the incoming page is still mid-flight one frame in', (
      tester,
    ) async {
      await pumpApp(tester);

      await tester.tap(find.widgetWithText(ListTile, '#general'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));

      final route = routeOf(tester, find.byType(ChannelDetailScreen))!;
      expect(route.animation!.value, greaterThan(0.0));
      expect(route.animation!.value, lessThan(1.0));

      await tester.pumpAndSettle();
      expect(route.animation!.value, 1.0);
    });
  });
}
