import 'package:sun_shine/core.dart';

class AuthRepositoryImpl extends BaseRepo implements AuthRepository {
  AuthRepositoryImpl({
    required AuthApiClient apiClient,
    required AuthLocalService localService,
  }) : _apiClient = apiClient,
       _localService = localService;

  final AuthApiClient _apiClient;
  final AuthLocalService _localService;

  @override
  Stream<Session?> get session => _localService.session;

  @override
  Session? get currentSession => _localService.currentSession;

  @override
  bool get isSignedIn => _localService.currentSession != null;

  @override
  Future<Result<Session>> signIn(String email, String password) async {
    final result = await _apiClient.signIn(email, password);
    switch (result) {
      case Ok<SessionApiModel>():
        final session = _toDomain(result.value);
        _localService.save(session);
        return Result.ok(session);
      case Error<SessionApiModel>():
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<void>> signOut() async {
    final result = await _apiClient.signOut();
    _localService.clear();
    return result;
  }

  Session _toDomain(SessionApiModel model) {
    final user = model.user;
    return Session(
      userId: user?.id ?? '',
      token: model.token,
      refreshToken: model.refreshToken,
      expireAt: model.expireAt,
      isTmpToken: model.isTmpToken ?? false,
      user: user == null
          ? null
          : User(
              id: user.id,
              email: user.email,
              fullName: user.fullName,
              avatar: user.avatar,
            ),
    );
  }
}
