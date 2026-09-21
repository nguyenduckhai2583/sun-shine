import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sun_shine/core.dart';

class SessionManager extends BaseRepo {
  SessionManager({required SessionRepository sessionRepository})
    : _sessionRepository = sessionRepository;

  final SessionRepository _sessionRepository;

  final _restored = BehaviorSubject<bool>.seeded(false);

  Stream<Session?> get activeSession => _sessionRepository.activeSession;

  Session? get currentSession => _sessionRepository.currentSession;

  bool get isSignedIn => _sessionRepository.isSignedIn;

  Stream<bool> get restored => _restored.stream.distinct();

  bool get isRestored => _restored.value;

  Future<void> initSession() async {
    if (_restored.value) return;
    try {
      await _sessionRepository.restore();
    } catch (error, stackTrace) {
      debugPrint('Session restore failed, starting signed out: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _restored.add(true);
    }
  }

  void dispose() {
    _restored.close();
    Di.observer.onDispose(this);
  }
}
