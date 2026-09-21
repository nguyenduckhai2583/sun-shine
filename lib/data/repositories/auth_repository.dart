import 'package:flutter/foundation.dart';

import '../../domain/models/user.dart';

/// Holds the session. It is a [ChangeNotifier] because the router listens to
/// it: sign in or out, it notifies, go_router re-runs `redirect`.
///
/// Consumers depend on this abstract type, never on the implementation.
abstract class AuthRepository extends ChangeNotifier {
  User? get currentUser;

  bool get isSignedIn;

  Future<void> signIn({required String email, required String password});

  void signOut();
}
