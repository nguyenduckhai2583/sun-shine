import 'package:sun_shine/core.dart';

class ChannelRepositoryImpl extends BaseRepo implements ChannelRepository {
  ChannelRepositoryImpl({
    required ChannelApiClient apiClient,
    required ChannelLocalService localService,
  }) : _apiClient = apiClient,
       _localService = localService;

  final ChannelApiClient _apiClient;
  final ChannelLocalService _localService;

  @override
  Stream<List<Channel>> get channels => _localService.channels;

  @override
  Stream<Channel?> watchChannel(String channelId) =>
      _localService.watch(channelId);

  @override
  Future<Result<List<Channel>>> loadChannels() async {
    final result = await _apiClient.getChannels();
    switch (result) {
      case Ok<List<ChannelApiModel>>():
        final channels = result.value.map(_toDomain).toList();
        _localService.replaceAll(channels);
        return Result.ok(channels);
      case Error<List<ChannelApiModel>>():
        return Result.error(result.error);
    }
  }

  /// The service has no endpoint for a single channel, so a miss is answered
  /// by loading the list and looking again.
  @override
  Future<Result<Channel>> loadChannel(String channelId) async {
    final cached = _localService.channelById(channelId);
    if (cached != null) return Result.ok(cached);

    final loaded = await loadChannels();
    if (loaded case Error(:final error)) return Result.error(error);

    final channel = _localService.channelById(channelId);
    if (channel == null) {
      return Result.error(ChannelNotFoundException(channelId));
    }
    return Result.ok(channel);
  }

  @override
  Future<Result<Channel>> updateChannelName(
    String channelId,
    String name,
  ) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.contains(' ')) {
      return Result.error(InvalidChannelNameException(name));
    }

    final current = _localService.channelById(channelId);
    if (current == null) {
      return Result.error(ChannelNotFoundException(channelId));
    }

    final result = await _apiClient.updateChannel(
      channelId,
      ChannelUpdateRequest(name: trimmed),
    );
    switch (result) {
      case Ok<void>():
        // The service answers with an empty body, so the rename is applied to
        // the copy we already hold.
        final renamed = current.copyWith(name: trimmed);
        _localService.upsert(renamed);
        return Result.ok(renamed);
      case Error<void>():
        return Result.error(result.error);
    }
  }

  Channel _toDomain(ChannelApiModel model) {
    return Channel(
      id: model.id,
      name: model.name ?? '',
      isPrivate: model.isPrivate,
      isEncrypted: model.isEncrypted,
    );
  }
}
