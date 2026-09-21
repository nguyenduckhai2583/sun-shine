import 'package:sun_shine/core.dart';

class SwitchAccountUseCase {
  SwitchAccountUseCase({
    required SessionRepository sessionRepository,
    required WorkspaceRepository workspaceRepository,
    required TokenRefreshApiClient tokenRefreshApiClient,
  }) : _sessionRepository = sessionRepository,
       _workspaceRepository = workspaceRepository,
       _tokenRefreshApiClient = tokenRefreshApiClient;

  final SessionRepository _sessionRepository;
  final WorkspaceRepository _workspaceRepository;
  final TokenRefreshApiClient _tokenRefreshApiClient;

  /// Makes [userId] the active account, renewing its token first when it has
  /// expired. A failed renew means the account is gone for good, so it is
  /// dropped instead of being left in a state the user cannot recover from.
  Future<Result<Session>> execute(String userId) async {
    final target = _sessionRepository.sessionOf(userId);
    if (target == null) {
      return const Result.error(ApiException(error: ApiErrorEnum.unknown));
    }
    if (_sessionRepository.currentSession?.userId == userId) {
      return Result.ok(target);
    }

    if (target.isTokenExpired) {
      final renewed = await _renew(target);
      if (renewed == null) {
        await _evict(userId);
        return const Result.error(
          ApiException(error: ApiErrorEnum.server, statusCode: 401),
        );
      }
      await _sessionRepository.setActive(userId);
      return Result.ok(renewed);
    }

    await _sessionRepository.setActive(userId);
    return Result.ok(target);
  }

  Future<Session?> _renew(Session target) async {
    final refreshToken = target.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) return null;

    final result = await _tokenRefreshApiClient.refresh(refreshToken);
    if (result case Ok(:final value)) {
      await _sessionRepository.renewToken(
        token: value.token,
        refreshToken: value.refreshToken,
        expireAt: value.expireAt,
        userId: target.userId,
      );
      return _sessionRepository.sessionOf(target.userId);
    }
    return null;
  }

  Future<void> _evict(String userId) async {
    await _sessionRepository.removeAccount(userId);
    await _workspaceRepository.removeAccount(userId);
  }
}
