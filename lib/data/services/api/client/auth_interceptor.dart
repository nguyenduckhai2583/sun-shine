import 'package:dio/dio.dart';

/// Attaches the active account's credentials to every request.
///
/// It reads through callbacks rather than holding a repository, so the data
/// layer never performs a provider lookup and the wiring stays explicit at the
/// place the `Dio` is built.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.readToken, required this.readWorkspaceId});

  final String? Function() readToken;
  final String? Function() readWorkspaceId;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // A header the caller already set wins. That is what makes a cross-account
    // call possible: it names its own account, and the active one must not
    // overwrite it.
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
