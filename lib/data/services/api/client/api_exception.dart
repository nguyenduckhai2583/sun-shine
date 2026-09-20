import 'dart:io';

import 'package:dio/dio.dart';

/// What went wrong, independent of any language.
///
/// The data layer has no `BuildContext`, so it must not decide wording: a
/// string chosen here would freeze into whatever locale was active when the
/// request failed. The view maps this to a localized message instead.
enum ApiErrorEnum {
  /// The request never reached the network.
  noInternet,

  /// The connection or the response ran out of time.
  timeout,

  /// The caller cancelled the request.
  cancelled,

  /// The certificate did not match what was configured.
  badCertificate,

  /// The response arrived but could not be parsed.
  badFormat,

  /// The server answered with an error — see [ApiException.serverMessage].
  server,

  unknown,
}

/// The single error type the data layer puts inside [Result.error].
///
/// [statusCode] is null when the failure never reached the server, or when it
/// carries a sentinel outside the HTTP range — callers branch on a real status
/// or on nothing at all.
class ApiException implements Exception {
  const ApiException({
    required this.error,
    this.serverMessage,
    this.statusCode,
  });

  final ApiErrorEnum error;

  /// The server's own text, from `{"error": "..."}`.
  ///
  /// Null unless [error] is [ApiErrorEnum.server]. This is the one message the
  /// app does not translate: it is the backend's wording, and only the backend
  /// knows what a given rejection means.
  final String? serverMessage;

  final int? statusCode;

  static const _timeout = 408;

  static ApiException from(Object error) {
    if (error is DioException) return _fromDio(error);
    if (error is SocketException) {
      return const ApiException(
        error: ApiErrorEnum.noInternet,
        statusCode: _timeout,
      );
    }
    if (error is FormatException) {
      return const ApiException(error: ApiErrorEnum.badFormat);
    }
    return const ApiException(error: ApiErrorEnum.unknown);
  }

  static ApiException _fromDio(DioException error) {
    final status = error.response?.statusCode;
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => ApiException(
        error: ApiErrorEnum.timeout,
        statusCode: status ?? _timeout,
      ),
      DioExceptionType.connectionError => ApiException(
        error: ApiErrorEnum.noInternet,
        statusCode: status ?? _timeout,
      ),
      DioExceptionType.cancel => ApiException(
        error: ApiErrorEnum.cancelled,
        statusCode: status,
      ),
      DioExceptionType.badCertificate => ApiException(
        error: ApiErrorEnum.badCertificate,
        statusCode: status,
      ),
      DioExceptionType.badResponse => ApiException(
        error: ApiErrorEnum.server,
        serverMessage: _serverMessage(error),
        statusCode: status,
      ),
      _ =>
        error.error is SocketException
            ? ApiException(
                error: ApiErrorEnum.noInternet,
                statusCode: status ?? _timeout,
              )
            : ApiException(
                error: ApiErrorEnum.server,
                serverMessage: _serverMessage(error),
                statusCode: status,
              ),
    };
  }

  /// The API reports failures as `{"error": "..."}`.
  static String? _serverMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['error'] != null) return data['error'].toString();
    return null;
  }

  /// Developer-facing only — never shown to a user, so English is fine here.
  @override
  String toString() =>
      'ApiException(${error.name}, $statusCode, ${serverMessage ?? '-'})';
}
