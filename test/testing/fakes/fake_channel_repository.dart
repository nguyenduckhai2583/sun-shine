import 'package:collection/collection.dart';
import 'package:sun_shine/core.dart';

class FakeChannelRepository implements ChannelRepository {
  FakeChannelRepository({List<Channel>? channels, this.failure})
    : _seed = channels ?? defaultChannels;

  static const defaultChannel = Channel(id: 'general', name: 'general');

  static const secondChannel = Channel(
    id: 'engineering',
    name: 'engineering',
    isPrivate: true,
  );

  static const defaultChannels = [defaultChannel, secondChannel];

  final List<Channel> _seed;
  final _localService = ChannelLocalService();

  Exception? failure;
  Exception? renameFailure;

  int loadCallCount = 0;
  final requestedIds = <String>[];
  final renameCalls = <(String, String)>[];

  @override
  Stream<List<Channel>> get channels => _localService.channels;

  @override
  Stream<Channel?> watchChannel(String channelId) =>
      _localService.watch(channelId);

  @override
  Future<Result<List<Channel>>> loadChannels() async {
    loadCallCount++;
    final failure = this.failure;
    if (failure != null) {
      return Result.error(failure);
    }
    _localService.replaceAll(_seed);
    return Result.ok(_seed);
  }

  @override
  Future<Result<Channel>> loadChannel(String channelId) async {
    requestedIds.add(channelId);
    final failure = this.failure;
    if (failure != null) {
      return Result.error(failure);
    }
    final cached = _localService.channelById(channelId);
    if (cached != null) {
      return Result.ok(cached);
    }
    final match = _seed.firstWhereOrNull((c) => c.id == channelId);
    if (match == null) {
      return Result.error(ChannelNotFoundException(channelId));
    }
    _localService.upsert(match);
    return Result.ok(match);
  }

  @override
  Future<Result<Channel>> updateChannelName(
    String channelId,
    String name,
  ) async {
    renameCalls.add((channelId, name));
    final failure = renameFailure ?? this.failure;
    if (failure != null) {
      return Result.error(failure);
    }
    final current =
        _localService.channelById(channelId) ??
        _seed.firstWhereOrNull((c) => c.id == channelId);
    if (current == null) {
      return Result.error(ChannelNotFoundException(channelId));
    }
    final renamed = current.copyWith(name: name);
    _localService.upsert(renamed);
    return Result.ok(renamed);
  }

  void dispose() => _localService.dispose();
}
