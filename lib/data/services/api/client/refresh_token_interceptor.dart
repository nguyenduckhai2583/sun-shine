import 'package:dio/dio.dart';

class _PendingRequest {
  const _PendingRequest(this.error, this.handler);

  final DioException error;
  final ErrorInterceptorHandler handler;
}

/// Renews an expired token and replays the request that hit the expiry.
///
/// The API distinguishes two failures: `440` means the token has expired and
/// can be renewed, `401` means it cannot. Only the first is worth a refresh —
/// retrying a `401` would loop.
class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor({
    required this.dio,
    required this.refresh,
    required this.onRefreshFailed,
  });

  /// Marks a request that authenticates as a specific, possibly inactive,
  /// account.
  ///
  /// Such a request must never be renewed or retried here: this interceptor is
  /// bound to the *active* account, so a retry would re-run the call as them
  /// and return their data instead.
  static const crossAccountKey = 'crossAccountRequest';

  static const _expiredStatus = 440;
  static const _invalidStatus = 401;

  final Dio dio;

  /// Returns the new token, or null when the session cannot be renewed.
  final Future<String?> Function() refresh;

  final void Function() onRefreshFailed;

  bool _isRefreshing = false;
  final List<_PendingRequest> _pending = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra[crossAccountKey] == true) {
      // The named account has no access to the active account's workspace, so
      // sending that header would earn a 403.
      options.headers.remove('x-workspace-id');
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;

    if (status == null || err.requestOptions.extra[crossAccountKey] == true) {
      handler.next(err);
      return;
    }

    if (status == _invalidStatus) {
      onRefreshFailed();
      handler.next(err);
      return;
    }

    if (status != _expiredStatus) {
      handler.next(err);
      return;
    }

    // A refresh is already running: wait for it rather than starting a second,
    // which would invalidate the first one's token.
    if (_isRefreshing) {
      _pending.add(_PendingRequest(err, handler));
      return;
    }

    _isRefreshing = true;
    String? token;
    try {
      token = await refresh();
    } catch (_) {
      token = null;
    }
    _isRefreshing = false;

    if (token == null || token.isEmpty) {
      onRefreshFailed();
      _rejectPending(err);
      handler.next(err);
      return;
    }

    await _replay(err, handler, token);
    await _drainPending(token);
  }

  Future<void> _drainPending(String token) async {
    final queued = List<_PendingRequest>.from(_pending);
    _pending.clear();
    await Future.wait(
      queued.map((req) => _replay(req.error, req.handler, token)),
    );
  }

  void _rejectPending(DioException cause) {
    final queued = List<_PendingRequest>.from(_pending);
    _pending.clear();
    for (final req in queued) {
      req.handler.next(
        DioException(
          requestOptions: req.error.requestOptions,
          response: cause.response,
          type: cause.type,
        ),
      );
    }
  }

  Future<void> _replay(
    DioException err,
    ErrorInterceptorHandler handler,
    String token,
  ) async {
    final request = err.requestOptions;
    final headers = Map<String, dynamic>.from(request.headers)
      ..['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.request<dynamic>(
        request.path,
        data: request.data,
        queryParameters: request.queryParameters,
        options: Options(
          method: request.method,
          headers: headers,
          sendTimeout: request.sendTimeout,
          receiveTimeout: request.receiveTimeout,
        ),
      );
      handler.resolve(response);
    } on DioException catch (error) {
      handler.next(error);
    }
  }
}
