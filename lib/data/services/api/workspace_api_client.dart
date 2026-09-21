import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sun_shine/core.dart';

part 'workspace_api_client.g.dart';

@RestApi(baseUrl: '/workspace-services', callAdapter: ResultCallAdapter)
abstract class WorkspaceApiClient {
  factory WorkspaceApiClient(Dio dio, {String? baseUrl}) = _WorkspaceApiClient;

  @GET('/workspaces/me')
  Future<Result<List<WorkspaceApiModel>>> getWorkspaces();

  /// Reads a background account's workspaces with that account's own token.
  /// The extra marks the call cross-account, so the refresh interceptor leaves
  /// it alone and the active account's workspace header is dropped.
  @GET('/workspaces/me')
  @Extra({RefreshTokenInterceptor.crossAccountKey: true})
  Future<Result<List<WorkspaceApiModel>>> getWorkspacesForToken(
    @Header('Authorization') String authorization,
  );
}
