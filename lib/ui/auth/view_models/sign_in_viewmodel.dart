import 'package:flutter/foundation.dart';

import '../../../data/repositories/auth_repository.dart';

class SignInViewModel extends ChangeNotifier {
  /// The repository arrives through the constructor. The view model has no
  /// idea where it came from, which is why it can be built in a test with a
  /// fake and no widget tree at all.
  SignInViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<void> signIn({required String email, required String password}) {
    // No navigation here. The repository notifies, the router's
    // refreshListenable fires, and `redirect` moves us to /students.
    return _authRepository.signIn(email: email, password: password);
  }
}
