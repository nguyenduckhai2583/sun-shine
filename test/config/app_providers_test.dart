import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

import '../testing/pump_app.dart';

void main() {
  testWidgets('channel data lives at the root, shared by every scope', (
    tester,
  ) async {
    await pumpApp(tester);

    final fromList = tester
        .element(find.widgetWithText(ListTile, '#general'))
        .read<ChannelRepository>();

    await tester.tap(find.widgetWithText(ListTile, '#general'));
    await tester.pumpAndSettle();

    final fromDetail = tester
        .element(find.text('128 members'))
        .read<ChannelRepository>();

    expect(
      identical(fromList, fromDetail),
      isTrue,
      reason: 'one source of truth for channels across both screens',
    );
  });
}
