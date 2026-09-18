import 'package:sun_shine/core.dart';

class AuthRepositoryRemote extends BaseRepo implements AuthRepository {
  AuthRepositoryRemote({
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
    return Session(
      userId: model.userId,
      email: model.email,
      accessToken: model.accessToken,
    );
  }
}
