import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../testing/pump_app.dart';

void main() {
  late StubHttpAdapter adapter;

  setUp(() => adapter = StubHttpAdapter());

  List<String?> channelRequestWorkspaces() => [
    for (final request in adapter.requests)
      if (request.uri.path == '/chat-services/channels')
        request.headers['x-workspace-id'] as String?,
  ];

  Future<void> openDrawer(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
  }

  testWidgets('switching workspace reloads the channels of that workspace', (
    tester,
  ) async {
    await pumpApp(tester, httpAdapter: adapter);

    expect(channelRequestWorkspaces(), ['w1']);

    await openDrawer(tester);
    await tester.tap(find.widgetWithText(ListTile, 'Design Team'));
    await tester.pumpAndSettle();

    expect(channelRequestWorkspaces(), [
      'w1',
      'ws_2',
    ], reason: 'the new workspace has its own channels, so they must be read');
  });

  testWidgets('staying on the same workspace reads nothing twice', (
    tester,
  ) async {
    await pumpApp(tester, httpAdapter: adapter);

    await openDrawer(tester);
    await tester.tap(find.widgetWithText(ListTile, 'Sun Shine'));
    await tester.pumpAndSettle();
    await openDrawer(tester);
    await tester.tap(find.widgetWithText(ListTile, 'Sun Shine'));
    await tester.pumpAndSettle();

    expect(channelRequestWorkspaces(), ['w1', 'ws_1']);
  });
}
