import 'package:sun_shine/core.dart';

class FakeChannelApiClient implements ChannelApiClient {
  FakeChannelApiClient({List<ChannelApiModel>? channels, this.failure})
    : channels = channels ?? defaultChannels;

  static const defaultChannel = ChannelApiModel(
    id: 'general',
    name: 'general',
    topic: 'Company-wide announcements',
    memberCount: 128,
  );

  static const secondChannel = ChannelApiModel(
    id: 'engineering',
    name: 'engineering',
    topic: 'Builds, reviews, incidents',
    memberCount: 42,
  );

  static const defaultChannels = [defaultChannel, secondChannel];

  static const asDomain = Channel(
    id: 'general',
    name: 'general',
    topic: 'Company-wide announcements',
    memberCount: 128,
  );

  List<ChannelApiModel> channels;
  Exception? failure;

  int getChannelsCallCount = 0;
  int getChannelCallCount = 0;

  @override
  Future<Result<List<ChannelApiModel>>> getChannels() async {
    getChannelsCallCount++;
    final failure = this.failure;
    if (failure != null) {
      return Result.error(failure);
    }
    return Result.ok(channels);
  }

  @override
  Future<Result<ChannelApiModel>> getChannel(String channelId) async {
    getChannelCallCount++;
    final failure = this.failure;
    if (failure != null) {
      return Result.error(failure);
    }
    final matches = channels.where((c) => c.id == channelId);
    if (matches.isEmpty) {
      return Result.error(ChannelNotFoundException(channelId));
    }
    return Result.ok(matches.first);
  }

  @override
  Future<Result<ChannelApiModel>> updateChannelName(
    String channelId,
    String name,
  ) async {
    final failure = this.failure;
    if (failure != null) {
      return Result.error(failure);
    }
    final index = channels.indexWhere((c) => c.id == channelId);
    if (index < 0) {
      return Result.error(ChannelNotFoundException(channelId));
    }
    final renamed = channels[index].copyWith(name: name);
    channels = [...channels]..[index] = renamed;
    return Result.ok(renamed);
  }
}
