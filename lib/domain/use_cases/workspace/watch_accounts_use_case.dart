import 'package:rxdart/rxdart.dart';
import 'package:sun_shine/core.dart';

/// One signed-in account with the workspaces it can reach.
typedef AccountGroup = ({
  Session session,
  bool isActive,
  List<Workspace> workspaces,
});

class WatchAccountsUseCase {
  WatchAccountsUseCase({
    required SessionRepository sessionRepository,
    required WorkspaceRepository workspaceRepository,
  }) : _sessionRepository = sessionRepository,
       _workspaceRepository = workspaceRepository;

  final SessionRepository _sessionRepository;
  final WorkspaceRepository _workspaceRepository;

  Stream<List<AccountGroup>> execute() {
    return Rx.combineLatest3(
      _sessionRepository.sessions,
      _sessionRepository.activeSession,
      _workspaceRepository.workspacesByAccount,
      _group,
    );
  }

  List<AccountGroup> current() => _group(
    _sessionRepository.allSessions,
    _sessionRepository.currentSession,
    const {},
  );

  List<AccountGroup> _group(
    List<Session> sessions,
    Session? active,
    Map<String, List<Workspace>> workspacesByAccount,
  ) {
    return [
      for (final session in sessions)
        (
          session: session,
          isActive: session.userId == active?.userId,
          workspaces:
              workspacesByAccount[session.userId] ??
              _workspaceRepository.workspacesOf(session.userId),
        ),
    ];
  }
}
