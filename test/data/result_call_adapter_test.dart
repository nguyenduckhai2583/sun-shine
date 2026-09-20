import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('ResultCallAdapter', () {
    test('wraps a value in Ok', () async {
      final adapter = ResultCallAdapter<int>();

      final result = await adapter.adapt(() async => 42);

      expect(result, isA<Ok<int>>());
      expect((result as Ok<int>).value, 42);
    });

    test('turns a thrown DioException into Error<ApiException>', () async {
      final adapter = ResultCallAdapter<int>();

      final result = await adapter.adapt(
        () async => throw DioException(
          requestOptions: RequestOptions(path: '/x'),
          response: Response(
            requestOptions: RequestOptions(path: '/x'),
            statusCode: 401,
            data: {'error': 'Unauthorized'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(result, isA<Error<int>>());
      final error = (result as Error<int>).error as ApiException;
      expect(error.error, ApiErrorEnum.server);
      expect(error.statusCode, 401);
      expect(error.serverMessage, 'Unauthorized');
    });

    test('never rethrows', () async {
      final adapter = ResultCallAdapter<int>();

      await expectLater(
        adapter.adapt(() async => throw Exception('boom')),
        completes,
      );
    });
  });
}
