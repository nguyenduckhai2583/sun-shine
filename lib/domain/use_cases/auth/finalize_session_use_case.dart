import 'package:sun_shine/core.dart';

/// Hands the pending session over to the session layer.
///
/// Everything before this point ran on the sign-in scoped Dio; after it the
/// account is live and the router's redirect takes the user onward.
class FinalizeSessionUseCase {
  FinalizeSessionUseCase({
    required AuthManager authManager,
    required SessionRepository sessionRepository,
  }) : _authManager = authManager,
       _sessionRepository = sessionRepository;

  final AuthManager _authManager;
  final SessionRepository _sessionRepository;

  Future<Result<Session>> execute() async {
    final pending = _authManager.pending;
    if (pending == null) {
      return const Result.error(ApiException(error: ApiErrorEnum.unknown));
    }
    // A temporary token still owes a second factor; adopting it would sign in
    // an account that has not finished authenticating.
    if (pending.isTmpToken) {
      return const Result.error(ApiException(error: ApiErrorEnum.unknown));
    }

    await _sessionRepository.adoptSession(pending);
    _authManager.reset();
    return Result.ok(pending);
  }
}
