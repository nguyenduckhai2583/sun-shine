import 'package:sun_shine/core.dart';

class SelectWorkspaceUseCase {
  SelectWorkspaceUseCase({
    required SessionRepository sessionRepository,
    required SwitchAccountUseCase switchAccountUseCase,
  }) : _sessionRepository = sessionRepository,
       _switchAccountUseCase = switchAccountUseCase;

  final SessionRepository _sessionRepository;
  final SwitchAccountUseCase _switchAccountUseCase;

  /// Picks a workspace, switching accounts first when the workspace belongs to
  /// someone other than the active account.
  Future<Result<Session>> execute({
    required String accountUserId,
    required String workspaceId,
  }) async {
    if (_sessionRepository.currentSession?.userId != accountUserId) {
      final switched = await _switchAccountUseCase.execute(accountUserId);
      if (switched case Error()) return switched;
    }

    await _sessionRepository.assignWorkspace(workspaceId);
    final session = _sessionRepository.currentSession;
    if (session == null) {
      return const Result.error(ApiException(error: ApiErrorEnum.unknown));
    }
    return Result.ok(session);
  }
}
