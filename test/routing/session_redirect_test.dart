import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('sessionRedirect', () {
    const user = User(id: 'u1', email: 'khai@sunshine.com');
    const noWorkspace = Session(userId: 'u1', token: 't', user: user);
    const ready = Session(
      userId: 'u1',
      token: 't',
      workspaceId: 'w1',
      user: user,
    );

    group('signed out', () {
      test('is sent to sign-in from anywhere else', () {
        expect(
          sessionRedirect(session: null, location: Routes.channels),
          Routes.signIn,
        );
        expect(
          sessionRedirect(session: null, location: Routes.workspace),
          Routes.signIn,
        );
      });

      test('is left alone once on sign-in', () {
        expect(sessionRedirect(session: null, location: Routes.signIn), isNull);
      });
    });

    group('signed in without a workspace', () {
      test('is sent to the workspace picker', () {
        expect(
          sessionRedirect(session: noWorkspace, location: Routes.signIn),
          Routes.workspace,
        );
        expect(
          sessionRedirect(session: noWorkspace, location: Routes.channels),
          Routes.workspace,
        );
      });

      test('is left alone once on the picker', () {
        expect(
          sessionRedirect(session: noWorkspace, location: Routes.workspace),
          isNull,
        );
      });
    });

    group('fully signed in', () {
      test('is pulled off sign-in and the picker', () {
        expect(
          sessionRedirect(session: ready, location: Routes.signIn),
          Routes.home,
        );
        expect(
          sessionRedirect(session: ready, location: Routes.workspace),
          Routes.home,
        );
      });

      test('is left alone anywhere in the app', () {
        expect(
          sessionRedirect(session: ready, location: Routes.channels),
          isNull,
        );
        expect(
          sessionRedirect(session: ready, location: Routes.planix),
          isNull,
        );
        expect(
          sessionRedirect(
            session: ready,
            location: Routes.channelDetail('general'),
          ),
          isNull,
        );
      });
    });

    test('assigning a workspace changes the destination', () {
      expect(
        sessionRedirect(session: noWorkspace, location: Routes.workspace),
        isNull,
      );
      expect(
        sessionRedirect(
          session: noWorkspace.copyWith(workspaceId: 'w1'),
          location: Routes.workspace,
        ),
        Routes.home,
      );
    });
  });
}
