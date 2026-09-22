import 'package:sun_shine/core.dart';

class FakeChannelApiClient implements ChannelApiClient {
  FakeChannelApiClient({List<ChannelApiModel>? channels, this.failure})
    : channels = channels ?? defaultChannels;

  static const defaultChannel = ChannelApiModel(id: 'general', name: 'general');

  static const secondChannel = ChannelApiModel(
    id: 'engineering',
    name: 'engineering',
    isPrivate: true,
  );

  static const defaultChannels = [defaultChannel, secondChannel];

  static const asDomain = Channel(id: 'general', name: 'general');

  List<ChannelApiModel> channels;
  Exception? failure;

  int getChannelsCallCount = 0;
  final List<(String, ChannelUpdateRequest)> updateCalls = [];

  @override
  Future<Result<List<ChannelApiModel>>> getChannels() async {
    getChannelsCallCount++;
    final failure = this.failure;
    if (failure != null) return Result.error(failure);
    return Result.ok(channels);
  }

  @override
  Future<Result<void>> updateChannel(
    String channelId,
    ChannelUpdateRequest request,
  ) async {
    updateCalls.add((channelId, request));
    final failure = this.failure;
    if (failure != null) return Result.error(failure);

    final index = channels.indexWhere((channel) => channel.id == channelId);
    if (index < 0) return Result.error(ChannelNotFoundException(channelId));

    channels = [...channels]
      ..[index] = channels[index].copyWith(
        name: request.name ?? channels[index].name,
      );
    return const Result.ok(null);
  }
}
