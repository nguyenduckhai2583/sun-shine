import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

class _FakeAdapter implements HttpClientAdapter {
  String body = '[]';
  int status = 200;

  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
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
  group('WorkspaceApiClient', () {
    late _FakeAdapter adapter;
    late WorkspaceApiClient client;

    setUp(() {
      adapter = _FakeAdapter();
      final dio = DioFactory.create(baseUrl: 'https://api.invalid')
        ..httpClientAdapter = adapter;
      client = WorkspaceApiClient(dio);
    });

    test('reads the workspace list off the bare json array', () async {
      adapter.body =
          '[{"id":"ws_1","name":"Sun Shine","isActive":true},'
          '{"id":"ws_2","name":"Design Team"}]';

      final result = await client.getWorkspaces();

      expect(result, isA<Ok<List<WorkspaceApiModel>>>());
      final workspaces = (result as Ok<List<WorkspaceApiModel>>).value;
      expect(workspaces.map((w) => w.id), ['ws_1', 'ws_2']);
      expect(
        adapter.requests.single.uri.path,
        '/workspace-services/workspaces/me',
      );
    });

    test('turns a server failure into an error result', () async {
      adapter.status = 500;

      final result = await client.getWorkspaces();

      expect(result, isA<Error<List<WorkspaceApiModel>>>());
    });

    test('sends no Authorization of its own for the active account', () async {
      await client.getWorkspaces();

      expect(adapter.requests.single.headers, isNot(contains('Authorization')));
      expect(
        adapter.requests.single.extra[RefreshTokenInterceptor.crossAccountKey],
        isNull,
      );
    });

    test(
      'carries a background account token and marks it cross-account',
      () async {
        await client.getWorkspacesForToken('Bearer tok_u2');

        final request = adapter.requests.single;
        expect(request.headers['Authorization'], 'Bearer tok_u2');
        expect(request.extra[RefreshTokenInterceptor.crossAccountKey], isTrue);
      },
    );
  });
}
