import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sun_shine/core.dart';

part 'token_refresh_api_client.g.dart';

/// Renewing a token is the one call that cannot go through the app's `Dio`.
///
/// It must not carry the expired `Authorization` header, and it must not pass
/// through [RefreshTokenInterceptor] — a 440 on the refresh itself would
/// trigger another refresh, forever. So it gets a bare client of its own.
@RestApi(baseUrl: '/user-services/auth', callAdapter: ResultCallAdapter)
abstract class TokenRefreshApiClient {
  factory TokenRefreshApiClient(Dio dio, {String? baseUrl}) =
      _TokenRefreshApiClient;

  @POST('/refresh-token')
  Future<Result<SessionApiModel>> refresh(
    @Field('refreshToken') String refreshToken,
  );
}
