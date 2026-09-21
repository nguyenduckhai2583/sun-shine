import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/fakes/fake_workspace_api_client.dart';
import '../../../testing/pump_app.dart';

void main() {
  group('WorkspaceScreen', () {
    testWidgets('a session with no workspace lands here', (tester) async {
      final auth = await pumpApp(tester, signedIn: false);

      await auth.adoptSession(fakeSession(workspaceId: null));
      await tester.pumpAndSettle();

      expect(find.byType(WorkspaceScreen), findsOneWidget);
      expect(find.text('Select Workspace'), findsOneWidget);
      expect(find.text('Please select a workspace to start'), findsOneWidget);
    });

    testWidgets('lists the workspaces of the account', (tester) async {
      final auth = await pumpApp(tester, signedIn: false);

      await auth.adoptSession(fakeSession(workspaceId: null));
      await tester.pumpAndSettle();

      expect(find.text('Sun Shine'), findsOneWidget);
      expect(find.text('Design Team'), findsOneWidget);
    });

    testWidgets('Next waits for a pick', (tester) async {
      final auth = await pumpApp(tester, signedIn: false);

      await auth.adoptSession(fakeSession(workspaceId: null));
      await tester.pumpAndSettle();

      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );

      await tester.tap(find.text('Design Team'));
      await tester.pumpAndSettle();

      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets('picking one and confirming opens the app', (tester) async {
      final auth = await pumpApp(tester, signedIn: false);

      await auth.adoptSession(fakeSession(workspaceId: null));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Design Team'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(FilledButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(auth.currentSession?.workspaceId, 'ws_2');
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('an account with no workspaces is told so', (tester) async {
      final auth = await pumpApp(
        tester,
        signedIn: false,
        workspaceApi: FakeWorkspaceApiClient(workspaces: const []),
      );

      await auth.adoptSession(fakeSession(workspaceId: null));
      await tester.pumpAndSettle();

      expect(
        find.textContaining("You don't have any workspace available"),
        findsOneWidget,
      );
      expect(find.byType(FilledButton), findsNothing);
    });

    testWidgets('signing out from here returns to sign-in', (tester) async {
      final auth = await pumpApp(tester, signedIn: false);

      await auth.adoptSession(fakeSession(workspaceId: null));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'Sign out'));
      await tester.pumpAndSettle();

      expect(find.byType(SignInScreen), findsOneWidget);
    });
  });
}
