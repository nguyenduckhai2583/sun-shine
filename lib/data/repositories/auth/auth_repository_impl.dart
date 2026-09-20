import 'package:sun_shine/core.dart';

class AuthRepositoryImpl extends BaseRepo implements AuthRepository {
  /// Two clients, because two of these calls are not the same kind of call.
  ///
  /// [signInClient] is anonymous — it belongs to the sign-in flow and must not
  /// carry the active account's headers. [sessionClient] is the opposite: it
  /// authenticates as whoever is signed in. Passing only one collapses that
  /// distinction, which is the bug this split exists to prevent.
  AuthRepositoryImpl({
    required AuthApiClient signInClient,
    AuthApiClient? sessionClient,
  }) : _signInClient = signInClient,
       _sessionClient = sessionClient ?? signInClient;

  final AuthApiClient _signInClient;
  final AuthApiClient _sessionClient;

  @override
  Future<Result<Session>> signInRemote(AuthRequest request) async {
    final result = await _signInClient.signIn(request);
    return switch (result) {
      Ok(:final value) => Result.ok(_toSession(value)),
      Error(:final error) => Result.error(error),
    };
  }

  @override
  Future<Result<User>> getMyProfileRemote() async {
    final result = await _sessionClient.getMyProfile();
    return switch (result) {
      Ok(:final value) => Result.ok(_toUser(value)),
      Error(:final error) => Result.error(error),
    };
  }

  @override
  Future<Result<void>> signOutRemote() => _sessionClient.signOut();

  Session _toSession(SessionApiModel model) {
    final user = model.user;
    return Session(
      userId: user?.id ?? '',
      token: model.token,
      refreshToken: model.refreshToken,
      expireAt: model.expireAt,
      isTmpToken: model.isTmpToken ?? false,
      user: user == null ? null : _toUser(user),
    );
  }

  User _toUser(UserApiModel model) => User(
    id: model.id,
    email: model.email,
    fullName: model.fullName,
    avatar: model.avatar,
  );
}
