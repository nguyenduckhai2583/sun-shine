import '../../domain/models/user.dart';

/// Holds the session. Exposes a [Stream], not a [ChangeNotifier] — the
/// architecture guide's shape for a repository: "a `UserProfileRepository`
/// class that exposes a `Stream<UserProfile?>`, which emits a new value
/// whenever the user signs in or out".
abstract class AuthRepository {
  Stream<User?> get user;

  /// The latest value, for callers that cannot await a stream — the router's
  /// `redirect` has to answer synchronously.
  User? get currentUser;

  bool get isSignedIn;

  Future<void> signIn({required String email, required String password});

  void signOut();
}
