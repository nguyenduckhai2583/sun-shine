import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sun_shine/core.dart';

part 'token_refresh_api_client.g.dart';

@RestApi(baseUrl: '/user-services/auth', callAdapter: ResultCallAdapter)
abstract class TokenRefreshApiClient {
  factory TokenRefreshApiClient(Dio dio, {String? baseUrl}) =
      _TokenRefreshApiClient;

  @POST('/refresh-token')
  Future<Result<SessionApiModel>> refresh(
    @Field('refreshToken') String refreshToken,
  );
}
