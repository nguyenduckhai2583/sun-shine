import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._respond);

  final int Function(RequestOptions options) _respond;

  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      '{"ok":true}',
      _respond(options),
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('RefreshTokenInterceptor', () {
    late Dio dio;
    late _FakeAdapter adapter;
    var refreshCount = 0;
    var failedCount = 0;

    void wire({
      required int status,
      required Future<String?> Function() refresh,
    }) {
      adapter = _FakeAdapter(
        (options) =>
            options.headers['Authorization'] == 'Bearer new' ? 200 : status,
      );
      dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'))
        ..httpClientAdapter = adapter;
      dio.interceptors.add(
        RefreshTokenInterceptor(
          dio: dio,
          refresh: refresh,
          onRefreshFailed: () => failedCount++,
        ),
      );
    }

    setUp(() {
      refreshCount = 0;
      failedCount = 0;
    });

    test('a 440 refreshes once and replays with the new token', () async {
      wire(
        status: 440,
        refresh: () async {
          refreshCount++;
          return 'new';
        },
      );

      final response = await dio.get<dynamic>('/thing');

      expect(response.statusCode, 200);
      expect(refreshCount, 1);
      expect(adapter.requests.last.headers['Authorization'], 'Bearer new');
      expect(failedCount, 0);
    });

    test('concurrent 440s share a single refresh', () async {
      wire(
        status: 440,
        refresh: () async {
          refreshCount++;
          await Future<void>.delayed(const Duration(milliseconds: 20));
          return 'new';
        },
      );

      final responses = await Future.wait([
        dio.get<dynamic>('/one'),
        dio.get<dynamic>('/two'),
        dio.get<dynamic>('/three'),
      ]);

      expect(
        refreshCount,
        1,
        reason: 'three expiries must not trigger three refreshes',
      );
      expect(responses.map((r) => r.statusCode), everyElement(200));
    });

    test('a failed refresh reports it and surfaces the error', () async {
      wire(
        status: 440,
        refresh: () async {
          refreshCount++;
          return null;
        },
      );

      await expectLater(
        dio.get<dynamic>('/thing'),
        throwsA(isA<DioException>()),
      );
      expect(refreshCount, 1);
      expect(failedCount, 1);
    });

    test('queued requests are rejected when the refresh fails', () async {
      wire(
        status: 440,
        refresh: () async {
          refreshCount++;
          await Future<void>.delayed(const Duration(milliseconds: 20));
          return null;
        },
      );

      final results = await Future.wait([
        dio.get<dynamic>('/one').then((_) => 'ok').catchError((_) => 'failed'),
        dio.get<dynamic>('/two').then((_) => 'ok').catchError((_) => 'failed'),
      ]);

      expect(results, ['failed', 'failed']);
      expect(refreshCount, 1);
    });

    test('a 401 does not refresh — the token is not renewable', () async {
      wire(
        status: 401,
        refresh: () async {
          refreshCount++;
          return 'new';
        },
      );

      await expectLater(
        dio.get<dynamic>('/thing'),
        throwsA(isA<DioException>()),
      );
      expect(refreshCount, 0);
      expect(failedCount, 1);
    });

    test('a 500 is passed straight through', () async {
      wire(
        status: 500,
        refresh: () async {
          refreshCount++;
          return 'new';
        },
      );

      await expectLater(
        dio.get<dynamic>('/thing'),
        throwsA(isA<DioException>()),
      );
      expect(refreshCount, 0);
      expect(failedCount, 0);
    });

    test('a cross-account request is never refreshed or retried', () async {
      wire(
        status: 440,
        refresh: () async {
          refreshCount++;
          return 'new';
        },
      );

      await expectLater(
        dio.get<dynamic>(
          '/thing',
          options: Options(
            extra: {RefreshTokenInterceptor.crossAccountKey: true},
          ),
        ),
        throwsA(isA<DioException>()),
      );

      expect(
        refreshCount,
        0,
        reason: 'refreshing would re-run the call as the active account',
      );
      expect(failedCount, 0);
    });

    test('a cross-account request drops the active workspace header', () async {
      wire(status: 200, refresh: () async => 'new');

      await dio.get<dynamic>(
        '/thing',
        options: Options(
          headers: {'x-workspace-id': 'w1'},
          extra: {RefreshTokenInterceptor.crossAccountKey: true},
        ),
      );

      expect(
        adapter.requests.single.headers.containsKey('x-workspace-id'),
        isFalse,
      );
    });
  });

  group('AuthInterceptor', () {
    late _FakeAdapter adapter;

    Dio wire({String? token, String? workspaceId}) {
      adapter = _FakeAdapter((_) => 200);
      final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'))
        ..httpClientAdapter = adapter;
      dio.interceptors.add(
        AuthInterceptor(
          readToken: () => token,
          readWorkspaceId: () => workspaceId,
        ),
      );
      return dio;
    }

    test('adds the bearer token and workspace', () async {
      await wire(token: 'tok', workspaceId: 'w1').get<dynamic>('/thing');

      final headers = adapter.requests.single.headers;
      expect(headers['Authorization'], 'Bearer tok');
      expect(headers['x-workspace-id'], 'w1');
    });

    test('adds nothing while signed out', () async {
      await wire().get<dynamic>('/thing');

      final headers = adapter.requests.single.headers;
      expect(headers.containsKey('Authorization'), isFalse);
      expect(headers.containsKey('x-workspace-id'), isFalse);
    });

    test('never overrides a token the caller set', () async {
      await wire(token: 'active').get<dynamic>(
        '/thing',
        options: Options(headers: {'Authorization': 'Bearer other-account'}),
      );

      expect(
        adapter.requests.single.headers['Authorization'],
        'Bearer other-account',
        reason: 'a cross-account call must run as the account it named',
      );
    });
  });
}
