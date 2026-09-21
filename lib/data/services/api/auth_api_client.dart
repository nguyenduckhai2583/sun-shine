import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sun_shine/core.dart';

part 'auth_api_client.g.dart';

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
