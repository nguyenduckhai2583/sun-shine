import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

import '../../testing/pump_app.dart';

void main() {
  testWidgets('homeProviders exposes the repository by abstract type', (
    tester,
  ) async {
    late WorkspaceRepository resolved;

    await tester.pumpWidget(
      MultiProvider(
        providers: homeProviders,
        child: Builder(
          builder: (context) {
            resolved = context.read<WorkspaceRepository>();
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(resolved, isA<WorkspaceRepositoryRemote>());
  });

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
