import 'package:rxdart/rxdart.dart';

import '../../../domain/models/user.dart';

/// The source of truth for the session.
///
/// A [BehaviorSubject] holds the latest value and replays it to whoever
/// subscribes later, which is what lets a screen mounted after sign-in still
/// see the user without asking for it.
class AuthLocalService {
  final _user = BehaviorSubject<User?>.seeded(null);

  Stream<User?> get user => _user.stream;

  User? get value => _user.value;

  void set(User? user) {
    if (_user.value == user) return;
    _user.add(user);
  }

  void dispose() => _user.close();
}
