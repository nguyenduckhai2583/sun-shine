import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/fakes/fake_channel_repository.dart';

void main() {
  group('ChannelsViewModel', () {
    late FakeChannelRepository repository;

    setUp(() => repository = FakeChannelRepository());

    ChannelsViewModel build() {
      final viewModel = ChannelsViewModel(channelRepository: repository);
      addTearDown(viewModel.dispose);
      return viewModel;
    }

    test('loads channels on construction', () async {
      final viewModel = build();
      await viewModel.load.execute();

      expect(viewModel.load.completed, isTrue);
      expect(viewModel.channels, FakeChannelRepository.defaultChannels);
    });

    test('surfaces a failure through the command', () async {
      repository.failure = Exception('offline');
      final viewModel = build();
      await viewModel.load.execute();

      expect(viewModel.load.error, isTrue);
      expect(viewModel.channels, isEmpty);
    });

    test('channels getter is unmodifiable', () async {
      final viewModel = build();
      await viewModel.load.execute();

      expect(
        () => viewModel.channels.add(FakeChannelRepository.defaultChannel),
        throwsUnsupportedError,
      );
    });
  });
}
