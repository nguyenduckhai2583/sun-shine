import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/fakes/fake_channel_repository.dart';

void main() {
  group('ChannelDetailViewModel', () {
    late FakeChannelRepository repository;

    setUp(() => repository = FakeChannelRepository());

    ChannelDetailViewModel build({String channelId = 'general'}) {
      final viewModel = ChannelDetailViewModel(
        channelId: channelId,
        channelRepository: repository,
      );
      addTearDown(viewModel.dispose);
      return viewModel;
    }

    test('loads its channel on construction', () async {
      final viewModel = build();
      await viewModel.load.execute();

      expect(viewModel.load.completed, isTrue);
      expect(viewModel.channel, FakeChannelRepository.defaultChannel);
    });

    test('asks the repository for the id it was given', () async {
      final viewModel = build(channelId: 'engineering');
      await viewModel.load.execute();

      expect(repository.requestedIds, contains('engineering'));
      expect(viewModel.channelId, 'engineering');
    });

    test('surfaces a failure through the command', () async {
      repository.failure = const ChannelNotFoundException('general');
      final viewModel = build();
      await viewModel.load.execute();

      expect(viewModel.load.error, isTrue);
      expect(viewModel.channel, isNull);
    });

    test('rename updates the channel through the stream', () async {
      final viewModel = build();
      await viewModel.load.execute();

      await viewModel.rename.execute('announcements');

      expect(viewModel.rename.completed, isTrue);
      expect(viewModel.channel?.name, 'announcements');
      expect(viewModel.channel?.displayName, '#announcements');
      expect(repository.renameCalls, [('general', 'announcements')]);
    });

    test('rename failure leaves the channel untouched', () async {
      final viewModel = build();
      await viewModel.load.execute();

      repository.renameFailure = Exception('server said no');
      await viewModel.rename.execute('announcements');

      expect(viewModel.rename.error, isTrue);
      expect(viewModel.channel?.name, 'general');
    });

    test('rename refuses to run twice concurrently', () async {
      final viewModel = build();
      await viewModel.load.execute();

      await Future.wait([
        viewModel.rename.execute('one'),
        viewModel.rename.execute('two'),
      ]);

      expect(repository.renameCalls, hasLength(1));
    });
  });
}
