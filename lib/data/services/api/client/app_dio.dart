import 'package:dio/dio.dart';
import 'package:sun_shine/core.dart';

abstract final class AppDio {
  static Dio create({
    required String baseUrl,
    required SessionRepository sessionRepository,
  }) {
    final refreshClient = TokenRefreshApiClient(
      DioFactory.create(baseUrl: baseUrl),
    );

    late final Dio dio;
    dio = DioFactory.create(baseUrl: baseUrl);
    dio.interceptors.addAll([
      AuthInterceptor(
        readToken: () => sessionRepository.currentSession?.token,
        readWorkspaceId: () => sessionRepository.currentSession?.workspaceId,
      ),
      RefreshTokenInterceptor(
        dio: dio,
        refresh: () async {
          final refreshToken = sessionRepository.currentSession?.refreshToken;
          if (refreshToken == null) return null;

          final result = await refreshClient.refresh(refreshToken);
          if (result case Ok(:final value)) {
            await sessionRepository.renewToken(
              token: value.token,
              refreshToken: value.refreshToken,
              expireAt: value.expireAt,
            );
            return value.token;
          }
          return null;
        },
        onRefreshFailed: sessionRepository.signOut,
      ),
    ]);
    return dio;
  }
}
