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

    group('before the stored session has been looked for', () {
      test('is held on the splash screen from anywhere', () {
        expect(
          sessionRedirect(
            session: null,
            isRestored: false,
            location: Routes.channels,
          ),
          Routes.splash,
        );
        expect(
          sessionRedirect(
            session: null,
            isRestored: false,
            location: Routes.signIn,
          ),
          Routes.splash,
        );
      });

      test('is left alone once on the splash screen', () {
        expect(
          sessionRedirect(
            session: null,
            isRestored: false,
            location: Routes.splash,
          ),
          isNull,
        );
      });
    });

    group('signed out', () {
      test('is sent to sign-in from anywhere else', () {
        expect(
          sessionRedirect(
            session: null,
            isRestored: true,
            location: Routes.channels,
          ),
          Routes.signIn,
        );
        expect(
          sessionRedirect(
            session: null,
            isRestored: true,
            location: Routes.workspace,
          ),
          Routes.signIn,
        );
      });

      test('leaves the splash screen for sign-in', () {
        expect(
          sessionRedirect(
            session: null,
            isRestored: true,
            location: Routes.splash,
          ),
          Routes.signIn,
        );
      });

      test('is left alone once on sign-in', () {
        expect(
          sessionRedirect(
            session: null,
            isRestored: true,
            location: Routes.signIn,
          ),
          isNull,
        );
      });
    });

    group('signed in without a workspace', () {
      test('is sent to the workspace picker', () {
        expect(
          sessionRedirect(
            session: noWorkspace,
            isRestored: true,
            location: Routes.signIn,
          ),
          Routes.workspace,
        );
        expect(
          sessionRedirect(
            session: noWorkspace,
            isRestored: true,
            location: Routes.channels,
          ),
          Routes.workspace,
        );
      });

      test('leaves the splash screen for the picker', () {
        expect(
          sessionRedirect(
            session: noWorkspace,
            isRestored: true,
            location: Routes.splash,
          ),
          Routes.workspace,
        );
      });

      test('is left alone once on the picker', () {
        expect(
          sessionRedirect(
            session: noWorkspace,
            isRestored: true,
            location: Routes.workspace,
          ),
          isNull,
        );
      });
    });

    group('fully signed in', () {
      test('is pulled off sign-in, the picker and the splash screen', () {
        expect(
          sessionRedirect(
            session: ready,
            isRestored: true,
            location: Routes.signIn,
          ),
          Routes.home,
        );
        expect(
          sessionRedirect(
            session: ready,
            isRestored: true,
            location: Routes.workspace,
          ),
          Routes.home,
        );
        expect(
          sessionRedirect(
            session: ready,
            isRestored: true,
            location: Routes.splash,
          ),
          Routes.home,
        );
      });

      test('is left alone anywhere in the app', () {
        expect(
          sessionRedirect(
            session: ready,
            isRestored: true,
            location: Routes.channels,
          ),
          isNull,
        );
        expect(
          sessionRedirect(
            session: ready,
            isRestored: true,
            location: Routes.planix,
          ),
          isNull,
        );
        expect(
          sessionRedirect(
            session: ready,
            isRestored: true,
            location: Routes.channelDetail('general'),
          ),
          isNull,
        );
      });
    });

    test('assigning a workspace changes the destination', () {
      expect(
        sessionRedirect(
          session: noWorkspace,
          isRestored: true,
          location: Routes.workspace,
        ),
        isNull,
      );
      expect(
        sessionRedirect(
          session: noWorkspace.copyWith(workspaceId: 'w1'),
          isRestored: true,
          location: Routes.workspace,
        ),
        Routes.home,
      );
    });

    group('while adding another account', () {
      test('opens sign-in even though someone is signed in', () {
        expect(
          sessionRedirect(
            session: ready,
            isRestored: true,
            isAddingAccount: true,
            location: Routes.channels,
          ),
          Routes.signIn,
        );
      });

      test('is left alone once on the sign-in screen', () {
        expect(
          sessionRedirect(
            session: ready,
            isRestored: true,
            isAddingAccount: true,
            location: Routes.signIn,
          ),
          isNull,
        );
      });

      test('still waits for the stored session to be looked for', () {
        expect(
          sessionRedirect(
            session: null,
            isRestored: false,
            isAddingAccount: true,
            location: Routes.channels,
          ),
          Routes.splash,
        );
      });

      test('cancelling hands the signed-in account back its home', () {
        expect(
          sessionRedirect(
            session: ready,
            isRestored: true,
            location: Routes.signIn,
          ),
          Routes.home,
        );
      });
    });
  });
}
