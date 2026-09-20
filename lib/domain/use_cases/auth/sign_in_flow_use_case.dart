import 'package:sun_shine/core.dart';

/// The sign-in flow's non-HTTP verbs, so ViewModels never reach [AuthManager].
class SignInFlowUseCase {
  SignInFlowUseCase({required AuthManager authManager})
    : _authManager = authManager;

  final AuthManager _authManager;

  bool get isAddingAccount => _authManager.isAddingAccount;

  void beginAddAccount() => _authManager.beginAddAccount();

  /// Back out of the sign-in screen: ends the flow.
  void cancel() => _authManager.reset();

  /// Back out of a step above the sign-in screen (auth code, passcode): drops
  /// the half-signed-in session, but the flow stays open.
  void discardAttempt() => _authManager.clearPending();
}
