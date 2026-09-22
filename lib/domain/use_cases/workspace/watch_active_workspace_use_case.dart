import 'package:sun_shine/core.dart';

class WatchActiveWorkspaceUseCase {
  WatchActiveWorkspaceUseCase({required SessionRepository sessionRepository})
    : _sessionRepository = sessionRepository;

  final SessionRepository _sessionRepository;

  /// The workspace the app is currently reading, across account switches too.
  Stream<String?> execute() =>
      _sessionRepository.activeSession.map((s) => s?.workspaceId).distinct();

  String? get current => _sessionRepository.currentSession?.workspaceId;
}
