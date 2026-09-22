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
  group('ChannelApiClient', () {
    late _FakeAdapter adapter;
    late ChannelApiClient client;

    setUp(() {
      adapter = _FakeAdapter();
      final dio = DioFactory.create(baseUrl: 'https://api.invalid')
        ..httpClientAdapter = adapter;
      client = ChannelApiClient(dio);
    });

    test('reads the channel list of the active workspace', () async {
      adapter.body =
          '[{"id":"general","name":"general","isPrivate":false},'
          '{"id":"secrets","name":"secrets","isPrivate":true,'
          '"isEncrypted":true}]';

      final result = await client.getChannels();

      expect(result, isA<Ok<List<ChannelApiModel>>>());
      final channels = (result as Ok<List<ChannelApiModel>>).value;
      expect(channels.map((c) => c.id), ['general', 'secrets']);
      expect(channels.last.isPrivate, isTrue);
      expect(channels.last.isEncrypted, isTrue);
      expect(adapter.requests.single.uri.path, '/chat-services/channels');
    });

    test('defaults the flags the wire leaves out', () async {
      adapter.body = '[{"id":"general","name":"general"}]';

      final result = await client.getChannels();

      final channel = (result as Ok<List<ChannelApiModel>>).value.single;
      expect(channel.isPrivate, isFalse);
      expect(channel.isEncrypted, isFalse);
    });

    test('turns a server failure into an error result', () async {
      adapter.status = 500;

      final result = await client.getChannels();

      expect(result, isA<Error<List<ChannelApiModel>>>());
    });

    test('renames a channel with a put carrying only the name', () async {
      adapter.body = '';

      final result = await client.updateChannel(
        'general',
        const ChannelUpdateRequest(name: 'announcements'),
      );

      expect(result, isA<Ok<void>>());
      final request = adapter.requests.single;
      expect(request.method, 'PUT');
      expect(request.uri.path, '/chat-services/channels/general');
      expect(request.data, {'name': 'announcements'});
    });

    test('a rename failure comes back as an error', () async {
      adapter.status = 403;

      final result = await client.updateChannel(
        'general',
        const ChannelUpdateRequest(name: 'announcements'),
      );

      expect(result, isA<Error<void>>());
    });
  });
}
