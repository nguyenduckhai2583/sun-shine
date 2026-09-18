import 'dart:async';

import 'package:sun_shine/core.dart';

class ChannelsViewModel extends BaseViewModel {
  ChannelsViewModel({required ChannelRepository channelRepository})
    : _channelRepository = channelRepository {
    _subscription = _channelRepository.channels.listen(_onChannels);
    load = Command0(_load)..execute();
  }

  final ChannelRepository _channelRepository;

  late final StreamSubscription<List<Channel>> _subscription;

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
    super.dispose();
  }
}
