import 'package:sun_shine/core.dart';

class SignOutUseCase {
  SignOutUseCase({
    required SessionRepository sessionRepository,
    required WorkspaceRepository workspaceRepository,
  }) : _sessionRepository = sessionRepository,
       _workspaceRepository = workspaceRepository;

  final SessionRepository _sessionRepository;
  final WorkspaceRepository _workspaceRepository;

  /// Signs out one account. The next account, if any, becomes active.
  Future<void> signOutAccount(String userId) async {
    await _sessionRepository.removeAccount(userId);
    await _workspaceRepository.removeAccount(userId);
  }

  Future<void> signOutActive() async {
    final active = _sessionRepository.currentSession;
    if (active == null) return;
    await signOutAccount(active.userId);
  }

  Future<void> signOutAll() async {
    await _sessionRepository.signOutAll();
    await _workspaceRepository.clear();
  }
}
