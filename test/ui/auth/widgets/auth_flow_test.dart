import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

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

    testWidgets('signing in from the form reaches home', (tester) async {
      await pumpApp(tester, signedIn: false);

      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.widgetWithText(ListTile, '#general'), findsOneWidget);
    });

    testWidgets('bad credentials keep the user on the form', (tester) async {
      await pumpApp(tester, signedIn: false);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'nope@sunshine.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        '',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();

      expect(find.byType(SignInScreen), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
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

      await auth.signIn('someone-else@sunshine.com', 'password');
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
