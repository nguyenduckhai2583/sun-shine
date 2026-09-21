import 'package:sun_shine/core.dart';

class SignInFlowUseCase {
  SignInFlowUseCase({required AuthManager authManager})
    : _authManager = authManager;

  final AuthManager _authManager;

  bool get isAddingAccount => _authManager.isAddingAccount;

  void beginAddAccount() => _authManager.beginAddAccount();

  void cancel() => _authManager.reset();

  void discardAttempt() => _authManager.clearPending();
}
