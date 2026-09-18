import 'package:sun_shine/core.dart';

class ChannelRepositoryRemote extends BaseRepo implements ChannelRepository {
  ChannelRepositoryRemote({
    required ChannelApiClient apiClient,
    required ChannelLocalService localService,
  }) : _apiClient = apiClient,
       _localService = localService;

  final ChannelApiClient _apiClient;
  final ChannelLocalService _localService;

  bool _loadedAll = false;

  @override
  Stream<List<Channel>> get channels => _localService.channels;

  @override
  Stream<Channel?> watchChannel(String channelId) =>
      _localService.watch(channelId);

  @override
  Future<Result<List<Channel>>> loadChannels() async {
    if (_loadedAll) return Result.ok(_localService.value);

    final result = await _apiClient.getChannels();
    switch (result) {
      case Ok<List<ChannelApiModel>>():
        final channels = result.value.map(_toDomain).toList();
        _localService.replaceAll(channels);
        _loadedAll = true;
        return Result.ok(channels);
      case Error<List<ChannelApiModel>>():
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<Channel>> loadChannel(String channelId) async {
    final cached = _localService.channelById(channelId);
    if (cached != null) return Result.ok(cached);

    final result = await _apiClient.getChannel(channelId);
    switch (result) {
      case Ok<ChannelApiModel>():
        final channel = _toDomain(result.value);
        _localService.upsert(channel);
        return Result.ok(channel);
      case Error<ChannelApiModel>():
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<Channel>> updateChannelName(
    String channelId,
    String name,
  ) async {
    final result = await _apiClient.updateChannelName(channelId, name);
    switch (result) {
      case Ok<ChannelApiModel>():
        final channel = _toDomain(result.value);
        _localService.upsert(channel);
        return Result.ok(channel);
      case Error<ChannelApiModel>():
        return Result.error(result.error);
    }
  }

  @override
  void invalidateCache() {
    _loadedAll = false;
    _localService.clear();
  }

  Channel _toDomain(ChannelApiModel model) {
    return Channel(
      id: model.id,
      name: model.name,
      topic: model.topic,
      memberCount: model.memberCount,
    );
  }
}
