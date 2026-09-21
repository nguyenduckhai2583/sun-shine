import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/student_repository.dart';
import '../../../data/repositories/student_repository_impl.dart';
import '../../../data/services/api/student_api_client.dart';
import '../../../data/services/local/student_local_service.dart';
import '../../../domain/models/user.dart';

/// The session scope: everything that belongs to *the signed-in user* and
/// must not outlive them.
///
/// The whole mechanism is the `key`. It carries the current user id, so:
///
/// * sign in — key `_anonymous` -> `u-1`: the subtree is built for the first
///   time, and these providers with it.
/// * sign out — key `u-1` -> `_anonymous`: the subtree is unmounted, every
///   provider below is disposed, `StudentLocalService.dispose()` closes its
///   subject, and the data goes with it.
/// * switch account — key `u-1` -> `u-2`: same teardown, fresh instances.
///
/// Only what the whole session needs lives here. The teacher module is
/// narrower than a session, so it owns its own scope — see the `ShellRoute`
/// in `routing/router.dart`.
class AuthScope extends StatefulWidget {
  const AuthScope({super.key, required this.child});

  final Widget child;

  @override
  State<AuthScope> createState() => _AuthScopeState();
}

class _AuthScopeState extends State<AuthScope> {
  late final AuthRepository _authRepository;
  late final Stream<User?> _user;

  @override
  void initState() {
    super.initState();
    _authRepository = context.read<AuthRepository>();
    // Built once, in initState: a stream created inside build would be a new
    // object every frame and StreamBuilder would resubscribe each time.
    //
    // `.distinct` on the id is what `context.select` used to do — only an
    // identity change rebuilds this scope, not every emission.
    _user = _authRepository.user.distinct(
      (previous, next) => previous?.id == next?.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _user,
      initialData: _authRepository.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;

        return MultiProvider(
          key: ValueKey(user?.id ?? '_anonymous'),
          providers: [
            Provider<User?>.value(value: user),
            Provider<StudentApiClient>(
              create: (context) => StudentApiClient(),
            ),
            // The only data-layer object that owns a resource, so it is the
            // only one that needs a dispose.
            Provider<StudentLocalService>(
              create: (context) => StudentLocalService(),
              dispose: (context, service) => service.dispose(),
            ),
            Provider<StudentRepository>(
              create: (context) => StudentRepositoryImpl(
                apiClient: context.read(),
                localService: context.read(),
              ),
            ),
          ],
          // Still ABOVE MaterialApp.router, because the detail routes push on
          // the root navigator: they are siblings of the list, not
          // descendants, so a scope mounted inside the router could not
          // reach them.
          child: widget.child,
        );
      },
    );
  }
}
