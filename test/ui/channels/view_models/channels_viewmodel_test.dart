import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/fakes/fake_channel_repository.dart';
import '../../../testing/fakes/fake_session_repository.dart';
import '../../../testing/pump_app.dart';

void main() {
  group('ChannelsViewModel', () {
    late FakeChannelRepository repository;
    late FakeSessionRepository sessions;

    setUp(() {
      repository = FakeChannelRepository();
      sessions = FakeSessionRepository();
      addTearDown(sessions.dispose);
    });

    ChannelsViewModel build() {
      final viewModel = ChannelsViewModel(
        channelRepository: repository,
        watchActiveWorkspaceUseCase: WatchActiveWorkspaceUseCase(
          sessionRepository: sessions,
        ),
      );
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

    test('reloads when the active workspace changes', () async {
      sessions.emit(fakeSession(workspaceId: 'w1'));
      final viewModel = build();
      await viewModel.load.execute();
      final before = repository.loadCallCount;

      sessions.emit(fakeSession(workspaceId: 'w2'));
      await pumpEventQueue();

      expect(repository.loadCallCount, greaterThan(before));
    });

    test('staying in the same workspace does not reload', () async {
      sessions.emit(fakeSession(workspaceId: 'w1'));
      final viewModel = build();
      await viewModel.load.execute();
      final before = repository.loadCallCount;

      sessions.emit(fakeSession(workspaceId: 'w1'));
      await pumpEventQueue();

      expect(repository.loadCallCount, before);
    });
  });
}
