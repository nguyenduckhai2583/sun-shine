import 'package:sun_shine/core.dart';

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
    if (pending.isTmpToken) {
      return const Result.error(ApiException(error: ApiErrorEnum.unknown));
    }

    await _sessionRepository.adoptSession(pending);
    _authManager.reset();
    return Result.ok(pending);
  }
}
