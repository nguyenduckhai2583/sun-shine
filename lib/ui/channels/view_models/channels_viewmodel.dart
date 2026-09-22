import 'dart:async';

import 'package:sun_shine/core.dart';

class ChannelsViewModel extends BaseViewModel {
  ChannelsViewModel({
    required ChannelRepository channelRepository,
    required WatchActiveWorkspaceUseCase watchActiveWorkspaceUseCase,
  }) : _channelRepository = channelRepository {
    _subscription = _channelRepository.channels.listen(_onChannels);
    load = Command0(_load)..execute();

    // Another workspace means another set of channels, and this screen stays
    // mounted across the switch, so it has to ask again itself.
    _workspaceSubscription = watchActiveWorkspaceUseCase
        .execute()
        .skip(1)
        .listen((_) => load.execute());
  }

  final ChannelRepository _channelRepository;

  late final StreamSubscription<List<Channel>> _subscription;
  late final StreamSubscription<String?> _workspaceSubscription;

  late final Command0<List<Channel>> load;

  List<Channel> _channels = const [];

  List<Channel> get channels => List.unmodifiable(_channels);

  void _onChannels(List<Channel> channels) {
    _channels = channels;
    notifyListeners();
  }

  Future<Result<List<Channel>>> _load() => _channelRepository.loadChannels();

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    unawaited(_workspaceSubscription.cancel());
    super.dispose();
  }
}
