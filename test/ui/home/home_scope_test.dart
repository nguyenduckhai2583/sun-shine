import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

import '../../testing/pump_app.dart';

void main() {
  testWidgets('each home scope builds its own workspace repository', (
    tester,
  ) async {
    Future<WorkspaceRepository> mountHome() async {
      await pumpApp(tester);
      return tester
          .element(find.byType(NavigationBar))
          .read<WorkspaceRepository>();
    }

    final first = await mountHome();
    expect(
      first,
      isA<WorkspaceRepositoryImpl>(),
      reason: 'the scope exposes the repository by its abstract type',
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();

    final second = await mountHome();

    expect(
      identical(first, second),
      isFalse,
      reason: 'workspace data stays scoped to the home shell',
    );
  });
}
