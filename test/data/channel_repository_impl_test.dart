import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../testing/fakes/fake_channel_api_client.dart';

void main() {
  group('ChannelRepositoryImpl', () {
    late FakeChannelApiClient apiClient;
    late ChannelLocalService localService;
    late ChannelRepositoryImpl repository;

    setUp(() {
      apiClient = FakeChannelApiClient();
      localService = ChannelLocalService();
      repository = ChannelRepositoryImpl(
        apiClient: apiClient,
        localService: localService,
      );
      addTearDown(localService.dispose);
    });

    test('maps the api model onto the domain model', () async {
      final result = await repository.loadChannel('general');

      expect(result, isA<Ok<Channel>>());
      expect((result as Ok<Channel>).value, FakeChannelApiClient.asDomain);
    });

    test('propagates a service failure', () async {
      apiClient.failure = const ChannelNotFoundException('nope');

      final result = await repository.loadChannel('nope');

      expect(result, isA<Error<Channel>>());
    });

    test('loadChannels caches the list', () async {
      await repository.loadChannels();
      await repository.loadChannels();

      expect(apiClient.getChannelsCallCount, 1);
    });

    test('a list read warms the per-id cache', () async {
      await repository.loadChannels();
      final result = await repository.loadChannel('engineering');

      expect(result, isA<Ok<Channel>>());
      expect(
        apiClient.getChannelCallCount,
        0,
        reason: 'served from the local service, no second round trip',
      );
    });

    test('invalidateCache forces a refetch', () async {
      await repository.loadChannels();
      repository.invalidateCache();
      await repository.loadChannels();

      expect(apiClient.getChannelsCallCount, 2);
    });

    test('the channels stream emits on load', () async {
      expect(
        repository.channels,
        emitsInOrder([const <Channel>[], hasLength(2)]),
      );

      await repository.loadChannels();
    });

    test('renaming emits the new value on watchChannel', () async {
      await repository.loadChannels();

      expect(
        repository.watchChannel('general'),
        emitsInOrder([
          isA<Channel>().having((c) => c.name, 'name', 'general'),
          isA<Channel>().having((c) => c.name, 'name', 'announcements'),
        ]),
      );

      await repository.updateChannelName('general', 'announcements');
    });

    test('renaming emits on the whole-list stream too', () async {
      await repository.loadChannels();

      final emissions = <List<Channel>>[];
      final sub = repository.channels.listen(emissions.add);
      addTearDown(sub.cancel);

      await repository.updateChannelName('general', 'announcements');
      await Future<void>.delayed(Duration.zero);

      expect(emissions.last.first.name, 'announcements');
    });
  });
}
