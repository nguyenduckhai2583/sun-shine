import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/pump_app.dart';

void main() {
  group('ChannelDetailScreen', () {
    testWidgets('deep link works with no extra and no parent scope', (
      tester,
    ) async {
      await pumpApp(tester, initialLocation: Routes.channelDetail('general'));

      expect(find.byType(ChannelDetailScreen), findsOneWidget);
      expect(find.text('#general'), findsWidgets);
      expect(find.text('Public channel'), findsOneWidget);
    });

    testWidgets('loads a different channel from the same route', (
      tester,
    ) async {
      await pumpApp(
        tester,
        initialLocation: Routes.channelDetail('engineering'),
      );

      expect(find.text('#engineering'), findsWidgets);
      expect(find.text('Private channel'), findsOneWidget);
    });

    testWidgets('shows retry when the channel does not exist', (tester) async {
      await pumpApp(tester, initialLocation: Routes.channelDetail('nope'));

      expect(find.text('Could not load #nope'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Retry'), findsOneWidget);
    });

    testWidgets('has its own scope, separate from home', (tester) async {
      await pumpApp(tester, initialLocation: Routes.home);
      await tester.tap(find.widgetWithText(ListTile, '#general'));
      await tester.pumpAndSettle();

      final context = tester.element(find.text('Public channel'));
      expect(context.read<ChannelDetailViewModel>().channelId, 'general');
      expect(
        () => context.read<HomeViewModel>(),
        throwsA(isA<ProviderNotFoundException>()),
        reason: 'the detail route lives outside the home shell scope',
      );
    });
  });
}
