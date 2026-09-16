import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sun_shine/core.dart';

class ChannelDetailViewModel extends ChangeNotifier {
  ChannelDetailViewModel({
    required String channelId,
    required ChannelRepository channelRepository,
  }) : _channelId = channelId,
       _channelRepository = channelRepository {
    _subscription = _channelRepository
        .watchChannel(_channelId)
        .listen(_onChannel);
    load = Command0(_load)..execute();
    rename = Command1(_rename);
  }

  final String _channelId;
  final ChannelRepository _channelRepository;

  late final StreamSubscription<Channel?> _subscription;

  String get channelId => _channelId;

  late final Command0<Channel> load;

  late final Command1<Channel, String> rename;

  Channel? _channel;

  Channel? get channel => _channel;

  void _onChannel(Channel? channel) {
    if (channel == null) return;
    _channel = channel;
    notifyListeners();
  }

  Future<Result<Channel>> _load() => _channelRepository.loadChannel(_channelId);

  Future<Result<Channel>> _rename(String name) =>
      _channelRepository.updateChannelName(_channelId, name);

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
