import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/fakes/fake_auth_api_client.dart';
import '../../../testing/pump_app.dart';

void main() {
  group('sign-in redirect', () {
    testWidgets('signed out lands on the sign-in screen', (tester) async {
      await pumpApp(tester, signedIn: false);

      expect(find.byType(SignInScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('a deep link while signed out is sent to sign-in', (
      tester,
    ) async {
      await pumpApp(
        tester,
        signedIn: false,
        initialLocation: Routes.channelDetail('general'),
      );

      expect(find.byType(SignInScreen), findsOneWidget);
      expect(find.byType(ChannelDetailScreen), findsNothing);
    });

    testWidgets('signed in skips the sign-in screen', (tester) async {
      await pumpApp(tester, initialLocation: Routes.signIn);

      expect(find.byType(SignInScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('the sign-in button waits for both fields', (tester) async {
      await pumpApp(tester, signedIn: false);

      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );

      await tester.enterText(find.byType(TextField).first, 'khai@sunshine.com');
      await tester.enterText(find.byType(TextField).last, 'password');
      await tester.pump();

      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets('signing in leaves the form for the workspace picker', (
      tester,
    ) async {
      await pumpApp(tester, signedIn: false);

      await tester.enterText(find.byType(TextField).first, 'khai@sunshine.com');
      await tester.enterText(find.byType(TextField).last, 'password');
      await tester.pump();
      await tester.ensureVisible(find.byType(FilledButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.byType(SignInScreen), findsNothing);
      expect(find.text('Workspace'), findsOneWidget);
    });

    testWidgets('bad credentials keep the user on the form', (tester) async {
      await pumpApp(
        tester,
        signedIn: false,
        authApi: FakeAuthApiClient()
          ..signInResult = const Result.error(
            ApiException(
              error: ApiErrorEnum.server,
              serverMessage: 'Invalid credentials',
              statusCode: 401,
            ),
          ),
      );

      await tester.enterText(find.byType(TextField).first, 'nope@sunshine.com');
      await tester.enterText(find.byType(TextField).last, 'wrong');
      await tester.pump();
      await tester.ensureVisible(find.byType(FilledButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.text('Invalid credentials'), findsOneWidget);
      expect(find.byType(SignInScreen), findsOneWidget);
    });
  });

  group('sign-out', () {
    Future<void> openDrawer(WidgetTester tester) async {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
    }

    testWidgets('returns to the sign-in screen', (tester) async {
      await pumpApp(tester);
      await openDrawer(tester);

      await tester.tap(find.widgetWithText(ListTile, 'Sign out'));
      await tester.pumpAndSettle();

      expect(find.byType(SignInScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('disposes every session-scoped provider', (tester) async {
      await pumpApp(tester);

      final localService = tester
          .element(find.widgetWithText(ListTile, '#general'))
          .read<ChannelLocalService>();
      expect(localService.isDisposed, isFalse);

      await openDrawer(tester);
      await tester.tap(find.widgetWithText(ListTile, 'Sign out'));
      await tester.pumpAndSettle();

      expect(
        localService.isDisposed,
        isTrue,
        reason: 'the session scope unmounted, so its caches went with it',
      );
    });

    testWidgets('a second user gets a fresh session scope', (tester) async {
      final auth = await pumpApp(tester);

      final firstService = tester
          .element(find.widgetWithText(ListTile, '#general'))
          .read<ChannelLocalService>();
      final firstRepository = tester
          .element(find.widgetWithText(ListTile, '#general'))
          .read<ChannelRepository>();

      await openDrawer(tester);
      await tester.tap(find.widgetWithText(ListTile, 'Sign out'));
      await tester.pumpAndSettle();

      await auth.adoptSession(
        fakeSession(userId: 'u2', email: 'someone-else@sunshine.com'),
      );
      await tester.pumpAndSettle();

      final secondService = tester
          .element(find.widgetWithText(ListTile, '#general'))
          .read<ChannelLocalService>();
      final secondRepository = tester
          .element(find.widgetWithText(ListTile, '#general'))
          .read<ChannelRepository>();

      expect(identical(firstService, secondService), isFalse);
      expect(identical(firstRepository, secondRepository), isFalse);
      expect(secondService.isDisposed, isFalse);
    });
  });
}
