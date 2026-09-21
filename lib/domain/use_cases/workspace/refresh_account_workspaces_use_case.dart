import 'package:sun_shine/core.dart';

class RefreshAccountWorkspacesUseCase {
  RefreshAccountWorkspacesUseCase({
    required SessionRepository sessionRepository,
    required WorkspaceRepository workspaceRepository,
  }) : _sessionRepository = sessionRepository,
       _workspaceRepository = workspaceRepository;

  final SessionRepository _sessionRepository;
  final WorkspaceRepository _workspaceRepository;

  /// Loads the cache, then refreshes every signed-in account. Only the active
  /// account's outcome is reported: a background account that fails keeps its
  /// cached workspaces, because being offline must not cost the user an
  /// account.
  Future<Result<List<Workspace>>> execute() async {
    await _workspaceRepository.restore();
    final sessions = _sessionRepository.allSessions;
    await _workspaceRepository.pruneExcept({
      for (final session in sessions) session.userId,
    });

    final active = _sessionRepository.currentSession;

    final background = Future.wait([
      for (final session in sessions)
        if (session.userId != active?.userId)
          _workspaceRepository.refresh(session.userId, token: session.token),
    ]);

    if (active == null) {
      await background;
      return const Result.ok([]);
    }

    final result = await _workspaceRepository.refresh(active.userId);
    await background;
    return result;
  }
}
