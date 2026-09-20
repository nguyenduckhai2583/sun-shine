import 'package:dio/dio.dart';
import 'package:sun_shine/core.dart';

/// Builds the `Dio` that authenticated calls travel on.
///
/// Distinct from [AuthManager]'s, which is deliberately anonymous so the
/// sign-in flow cannot inherit the active account's headers. This one is the
/// opposite: it carries them, and renews them when the server says they have
/// expired.
abstract final class AppDio {
  static Dio create({
    required String baseUrl,
    required SessionRepository sessionRepository,
  }) {
    // The refresh call rides its own bare client — see TokenRefreshApiClient.
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
        // Nothing can renew this session, so the account goes. The router is
        // watching the session stream and will move the user to sign-in.
        onRefreshFailed: sessionRepository.signOut,
      ),
    ]);
    return dio;
  }
}
