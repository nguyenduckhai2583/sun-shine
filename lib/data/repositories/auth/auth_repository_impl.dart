import 'package:sun_shine/core.dart';

class AuthRepositoryImpl extends BaseRepo implements AuthRepository {
  AuthRepositoryImpl({required AuthApiClient client}) : _client = client;

  final AuthApiClient _client;

  @override
  Future<Result<Session>> signInRemote(AuthRequest request) async {
    final result = await _client.signIn(request);
    return switch (result) {
      Ok(:final value) => Result.ok(_toSession(value)),
      Error(:final error) => Result.error(error),
    };
  }

  @override
  Future<Result<User>> getMyProfileRemote() async {
    final result = await _client.getMyProfile();
    return switch (result) {
      Ok(:final value) => Result.ok(_toUser(value)),
      Error(:final error) => Result.error(error),
    };
  }

  @override
  Future<Result<void>> signOutRemote() => _client.signOut();

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
    fullName: model.displayName,
    avatar: model.avatar,
  );
}
