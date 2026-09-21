import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:sun_shine/core.dart';

class _CapturingOutput extends LogOutput {
  final List<String> entries = [];

  @override
  void output(OutputEvent event) => entries.add(event.lines.join('\n'));
}

class _FakeAdapter implements HttpClientAdapter {
  String body = '{"ok":true}';
  int status = 200;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _CapturingOutput logs;
  late _FakeAdapter adapter;
  late Dio dio;

  String all() => logs.entries.join('\n');

  setUp(() {
    logs = _CapturingOutput();
    LogUtils.init(isDebug: true, logOutput: logs);

    adapter = _FakeAdapter();
    dio = DioFactory.create(baseUrl: 'https://api.invalid')
      ..httpClientAdapter = adapter;
  });

  tearDown(() => LogUtils.init(logOutput: _CapturingOutput()));

  group('ApiLogInterceptor', () {
    test('announces the request before it goes out', () async {
      await dio.get<dynamic>('/workspaces/me');

      expect(
        logs.entries.first,
        contains('[API Request] Method: GET, Path: /workspaces/me'),
      );
    });

    test('prints the http log block for a response', () async {
      adapter.body = '[{"id":"ws_1","name":"Sun Shine"}]';

      await dio.get<dynamic>('/workspaces/me');

      expect(all(), contains('----------------Http Log---------------'));
      expect(all(), contains('[statusCode]:\t200'));
      expect(
        all(),
        contains(
          '[request]:\tmethod: GET  '
          'baseUrl: https://api.invalid  '
          'path: /workspaces/me',
        ),
      );
      expect(all(), contains('[response]:\t[{id: ws_1, name: Sun Shine}]'));
      expect(all(), contains('----------------End Log----------------'));
    });

    test('prints the block for a failure too', () async {
      adapter.status = 500;
      adapter.body = '{"message":"boom"}';

      await expectLater(
        dio.get<dynamic>('/boom'),
        throwsA(isA<DioException>()),
      );

      expect(all(), contains('[statusCode]:\t500'));
      expect(all(), contains('path: /boom'));
      expect(all(), contains('message: boom'));
    });

    test('writes the payload as it is, credentials included', () async {
      await dio.post<dynamic>(
        '/auth/sign-in',
        data: {'email': 'khai@sunshine.com', 'sha1Password': 'super-secret'},
      );

      expect(
        all(),
        contains('[API Request] Method: POST, Path: /auth/sign-in'),
      );
      expect(all(), contains('{ok: true}'));
    });

    test('stays quiet outside debug', () async {
      LogUtils.init(logOutput: logs);

      await dio.get<dynamic>('/workspaces/me');

      expect(logs.entries, isEmpty);
    });
  });
}
