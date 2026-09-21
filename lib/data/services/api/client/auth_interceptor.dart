import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.readToken, required this.readWorkspaceId});

  final String? Function() readToken;
  final String? Function() readWorkspaceId;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!options.headers.containsKey('Authorization')) {
      final token = readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    if (!options.headers.containsKey('x-workspace-id')) {
      final workspaceId = readWorkspaceId();
      if (workspaceId != null && workspaceId.isNotEmpty) {
        options.headers['x-workspace-id'] = workspaceId;
      }
    }

    handler.next(options);
  }
}
