import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/student_repository.dart';
import '../../../data/repositories/student_repository_impl.dart';
import '../../../data/services/api/student_api_client.dart';
import '../../../data/services/local/student_local_service.dart';
import '../bloc/auth_bloc.dart';

/// The session scope: everything that belongs to *the signed-in user* and
/// must not outlive them.
///
/// The mechanism is the `key`. It carries the current user id, so:
///
/// * sign in — key `_anonymous` -> `u-1`: the subtree is built, providers
///   with it.
/// * sign out — key `u-1` -> `_anonymous`: the subtree is unmounted,
///   everything below is disposed, `StudentLocalService.dispose()` closes
///   its subject, and the data goes with it.
/// * switch account — key `u-1` -> `u-2`: same teardown, fresh instances.
class AuthScope extends StatelessWidget {
  const AuthScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      // Only an identity change rebuilds this scope. `buildWhen` is bloc's
      // version of `context.select` — same subscription, fewer rebuilds.
      buildWhen: (previous, current) => previous.user?.id != current.user?.id,
      builder: (context, state) {
        return MultiRepositoryProvider(
          key: ValueKey(state.user?.id ?? '_anonymous'),
          providers: [
            RepositoryProvider<StudentApiClient>(
              create: (context) => StudentApiClient(),
            ),
            // The only data-layer object owning a resource, so the only one
            // that needs a dispose.
            RepositoryProvider<StudentLocalService>(
              create: (context) => StudentLocalService(),
              dispose: (service) => service.dispose(),
            ),
            RepositoryProvider<StudentRepository>(
              create: (context) => StudentRepositoryImpl(
                apiClient: context.read(),
                localService: context.read(),
              ),
            ),
          ],
          // Still ABOVE MaterialApp.router, because the detail routes push
          // on the root navigator: they are siblings of the list, not
          // descendants, so a scope inside the router could not reach them.
          child: child,
        );
      },
    );
  }
}
