import 'package:sun_shine/core.dart';

abstract class ChannelRepository {
  Stream<List<Channel>> get channels;

  Stream<Channel?> watchChannel(String channelId);

  Future<Result<List<Channel>>> loadChannels();

  Future<Result<Channel>> loadChannel(String channelId);

  Future<Result<Channel>> updateChannelName(String channelId, String name);

  void invalidateCache();
}
