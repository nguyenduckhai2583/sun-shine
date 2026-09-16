import 'package:rxdart/rxdart.dart';
import 'package:sun_shine/core.dart';

class AuthLocalService {
  final _session = BehaviorSubject<Session?>.seeded(null);

  Stream<Session?> get session => _session.stream.distinct();

  Session? get currentSession => _session.value;

  void save(Session session) {
    if (_session.value == session) return;
    _session.add(session);
  }

  void clear() {
    if (_session.value == null) return;
    _session.add(null);
  }

  bool get isDisposed => _session.isClosed;

  void dispose() {
    _session.close();
  }
}
