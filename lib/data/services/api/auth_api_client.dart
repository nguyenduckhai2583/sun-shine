import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sun_shine/core.dart';

part 'auth_api_client.g.dart';

/// `baseUrl` here is only the path prefix — the host comes from
/// `Dio.options.baseUrl`, so the environment stays a runtime value.
///
/// Every method returns a [Result] rather than throwing, because
/// [ResultCallAdapter] wraps each generated call.
@RestApi(baseUrl: '/user-services', callAdapter: ResultCallAdapter)
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String? baseUrl}) = _AuthApiClient;

  @POST('/auth/sign-in')
  Future<Result<SessionApiModel>> signIn(@Body() AuthRequest request);

  @GET('/users/me')
  Future<Result<UserApiModel>> getMyProfile();

  @DELETE('/auth/sign-out')
  Future<Result<void>> signOut();
}
