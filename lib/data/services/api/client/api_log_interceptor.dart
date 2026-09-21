import 'package:dio/dio.dart';
import 'package:sun_shine/core.dart';

/// Prints requests the way the employer app does: a line when the call goes
/// out, and an `Http Log` block when it comes back.
class ApiLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LogUtils.d(
      '[API Request] Method: ${options.method}, Path: ${options.path}',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    printHttpLog(
      statusCode: response.statusCode,
      request: response.requestOptions,
      data: response.data,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    printHttpLog(
      statusCode: err.response?.statusCode,
      request: err.requestOptions,
      data: err.response?.data ?? err.message,
    );
    handler.next(err);
  }

  static void printHttpLog({
    required int? statusCode,
    required RequestOptions request,
    required Object? data,
  }) {
    try {
      LogUtils.d(
        '----------------Http Log---------------\n'
        '[statusCode]:\t$statusCode\n'
        '[request]:\t${_requestOptionsStr(request)}\n'
        '[response]:\t$data\n'
        '----------------End Log----------------',
      );
    } on Object catch (ex) {
      LogUtils.e('Http Log  error...... $ex');
    }
  }

  static String _requestOptionsStr(RequestOptions request) =>
      'method: ${request.method}  '
      'baseUrl: ${request.baseUrl}  '
      'path: ${request.path}';
}
