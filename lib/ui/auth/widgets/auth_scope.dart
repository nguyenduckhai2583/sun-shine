import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/student_repository.dart';
import '../../../data/repositories/student_repository_impl.dart';
import '../../../data/services/api/student_api_client.dart';

/// The session scope: everything that belongs to *the signed-in user* and
/// must not outlive them.
///
/// Only what the whole session needs lives here. The teacher module is
/// narrower than a session, so it owns its own scope — see the `ShellRoute`
/// in `routing/router.dart`.
///
/// The whole mechanism is the `key`. It carries the current user id, so:
///
/// * sign in — key `_anonymous` -> `u-1`: the subtree is built for the first
///   time, and these providers with it.
/// * sign out — key `u-1` -> `_anonymous`: the subtree is unmounted and every
///   provider below is disposed, caches included.
/// * switch account — key `u-1` -> `u-2`: same teardown, fresh instances.
///
/// This is `get_it`'s `pushScope`/`popScope` written in provider: a scope
/// pushed at login and popped at logout. The alternative — the one the
/// official Compass sample takes — is to register everything at the root and
/// clear each cache by hand in the logout path. That works, but the list of
/// things to clear is one somebody has to keep correct forever. Here, a new
/// per-user provider added to this list gets clear-on-sign-out for free.
class AuthScope extends StatelessWidget {
  const AuthScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // `select`, so this rebuilds only when the identity changes — not on
    // every notification AuthRepository sends.
    final userId = context.select<AuthRepository, String?>(
      (repository) => repository.currentUser?.id,
    );

    return MultiProvider(
      key: ValueKey(userId ?? '_anonymous'),
      providers: [
        Provider<StudentApiClient>(create: (context) => FakeStudentApiClient()),
        Provider<StudentRepository>(
          create: (context) => StudentRepositoryImpl(apiClient: context.read()),
        ),
      ],
      // Still ABOVE MaterialApp.router, because the detail routes push on the
      // root navigator: they are siblings of the home shell, not descendants,
      // so a scope mounted inside the router could not reach them.
      child: child,
    );
  }
}
