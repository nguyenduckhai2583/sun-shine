import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('ApiException.from', () {
    DioException badResponse({Object? data, int statusCode = 400}) {
      return DioException(
        requestOptions: RequestOptions(path: '/x'),
        response: Response(
          requestOptions: RequestOptions(path: '/x'),
          statusCode: statusCode,
          data: data,
        ),
        type: DioExceptionType.badResponse,
      );
    }

    test('keeps the server error body verbatim', () {
      final mapped = ApiException.from(
        badResponse(data: {'error': 'Email already taken'}),
      );

      expect(mapped.error, ApiErrorEnum.server);
      expect(mapped.serverMessage, 'Email already taken');
      expect(mapped.statusCode, 400);
    });

    test('a server error without a body carries no message to show', () {
      final mapped = ApiException.from(badResponse(data: null));

      expect(mapped.error, ApiErrorEnum.server);
      expect(mapped.serverMessage, isNull);
    });

    test('maps a connection timeout to the timeout kind and 408', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: DioExceptionType.connectionTimeout,
      );

      final mapped = ApiException.from(error);

      expect(mapped.error, ApiErrorEnum.timeout);
      expect(mapped.statusCode, 408);
    });

    test('maps a socket failure to the no-internet kind', () {
      final mapped = ApiException.from(const SocketException('no route'));

      expect(mapped.error, ApiErrorEnum.noInternet);
      expect(mapped.statusCode, 408);
    });

    test('maps a cancellation to the cancelled kind', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: DioExceptionType.cancel,
      );

      expect(ApiException.from(error).error, ApiErrorEnum.cancelled);
    });

    test('falls back for an unknown error', () {
      final mapped = ApiException.from(Exception('boom'));

      expect(mapped.error, ApiErrorEnum.unknown);
      expect(mapped.statusCode, isNull);
    });

    test('carries no user-facing English of its own', () {
      final mapped = ApiException.from(
        DioException(
          requestOptions: RequestOptions(path: '/x'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(mapped.serverMessage, isNull);
    });
  });
}
