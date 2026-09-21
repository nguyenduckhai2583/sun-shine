import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sun_shine/data/repositories/auth_repository.dart';
import 'package:sun_shine/data/repositories/auth_repository_impl.dart';
import 'package:sun_shine/data/services/api/auth_api_client.dart';
import 'package:sun_shine/ui/auth/widgets/auth_scope.dart';

/// Pins the two properties `AuthScope` is built on:
///
/// 1. `Provider` is lazy. Declaring a provider does NOT build its value —
///    `create` runs on the first read and never before. So the `_anonymous`
///    scope declares four providers and constructs none of them.
/// 2. Changing the key of the subtree disposes whatever WAS built, and the
///    next session starts from scratch.
void main() {
  testWidgets('a declared provider stays unbuilt until something reads it', (
    tester,
  ) async {
    _Session.created = 0;
    _Session.disposed = 0;

    // Signed out: the scope exists, nothing reads it.
    await tester.pumpWidget(_harness(read: false));
    expect(
      _Session.created,
      0,
      reason: 'declaring a lazy provider must not build its value',
    );

    // Sign in, and a screen reads the repository.
    await tester.pumpWidget(_harness(userId: 'u-1', read: true));
    expect(_Session.created, 1);
    expect(find.text('u-1'), findsOneWidget);

    // Sign out: the key flips, the built value is disposed, and the new
    // anonymous scope builds nothing.
    await tester.pumpWidget(_harness(read: false));
    expect(_Session.disposed, 1);
    expect(
      _Session.created,
      1,
      reason: 'the signed-out scope declares providers but builds none',
    );

    // A different user gets a different instance, never the first one's.
    await tester.pumpWidget(_harness(userId: 'u-2', read: true));
    expect(_Session.created, 2);
    expect(find.text('u-2'), findsOneWidget);
  });

  group('AuthScope + context.select', _selectRebuildTests);
}

/// Proves `context.select` inside the real [AuthScope] reacts to sign-out.
///
/// The probe is the `MultiProvider` widget AuthScope returns. A widget object
/// is only constructed by a `build`, so:
///
/// * a NEW MultiProvider instance in the tree  => AuthScope rebuilt
/// * the SAME instance still in the tree       => AuthScope did not rebuild
///
/// Nothing calls `pumpWidget` after the first frame, so the only thing that
/// can rebuild AuthScope is its own dependency on AuthRepository.
void _selectRebuildTests() {
  MultiProvider scope(WidgetTester tester) =>
      tester.widget<MultiProvider>(find.byType(MultiProvider));

  testWidgets('signing out rebuilds AuthScope and flips its key', (
    tester,
  ) async {
    final auth = AuthRepositoryImpl(apiClient: FakeAuthApiClient());
    addTearDown(auth.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthRepository>.value(
        value: auth,
        child: const AuthScope(child: SizedBox()),
      ),
    );
    expect(scope(tester).key, const ValueKey('_anonymous'));

    await auth.signIn(email: 'khai@sunshine.edu', password: 'password');
    await tester.pump();
    expect(
      scope(tester).key,
      const ValueKey('u-1'),
      reason: 'sign-in must rebuild AuthScope with the user key',
    );

    final beforeSignOut = scope(tester);

    auth.signOut();
    await tester.pump();

    expect(
      scope(tester).key,
      const ValueKey('_anonymous'),
      reason: 'sign-out must rebuild AuthScope back to the anonymous key',
    );
    expect(
      identical(beforeSignOut, scope(tester)),
      isFalse,
      reason: 'a new MultiProvider instance proves build() ran again',
    );
  });

  testWidgets('a notification that does not change the user id does not '
      'rebuild AuthScope', (tester) async {
    final auth = AuthRepositoryImpl(apiClient: FakeAuthApiClient());
    addTearDown(auth.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthRepository>.value(
        value: auth,
        child: const AuthScope(child: SizedBox()),
      ),
    );

    await auth.signIn(email: 'khai@sunshine.edu', password: 'password');
    await tester.pump();
    final afterFirstSignIn = scope(tester);

    // Same user signs in again: notifyListeners fires, the id is unchanged.
    await auth.signIn(email: 'khai@sunshine.edu', password: 'password');
    await tester.pump();

    expect(
      identical(afterFirstSignIn, scope(tester)),
      isTrue,
      reason: 'select filtered the notification out; watch would not have',
    );
  });
}

/// Stands in for a session-scoped repository.
class _Session {
  _Session(this.userId) {
    created++;
  }

  static int created = 0;
  static int disposed = 0;

  final String userId;

  void dispose() => disposed++;
}

/// The same shape as `AuthScope`: a keyed scope over a subtree.
Widget _harness({String? userId, required bool read}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MultiProvider(
    key: ValueKey(userId ?? '_anonymous'),
    providers: [
      Provider<_Session>(
        create: (context) => _Session(userId ?? '_anonymous'),
        dispose: (context, session) => session.dispose(),
      ),
    ],
    child: Builder(
      builder: (context) =>
          Text(read ? context.read<_Session>().userId : 'signed out'),
    ),
  ),
);
