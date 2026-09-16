import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sun_shine/core.dart';

class ChannelLocalService {
  final _channels = BehaviorSubject<List<Channel>>.seeded(const []);

  Stream<List<Channel>> get channels => _channels.stream;

  List<Channel> get value => _channels.value;

  Stream<Channel?> watch(String channelId) => _channels.stream
      .map((list) => list.firstWhereOrNull((c) => c.id == channelId))
      .distinct();

  Channel? channelById(String channelId) =>
      _channels.value.firstWhereOrNull((c) => c.id == channelId);

  void replaceAll(List<Channel> channels) {
    _channels.add(List.unmodifiable(channels));
  }

  void upsert(Channel channel) {
    final current = List<Channel>.from(_channels.value);
    final index = current.indexWhere((c) => c.id == channel.id);
    if (index == -1) {
      current.add(channel);
    } else {
      if (current[index] == channel) return;
      current[index] = channel;
    }
    _channels.add(List.unmodifiable(current));
  }

  void clear() {
    _channels.add(const []);
  }

  bool get isDisposed => _channels.isClosed;

  void dispose() {
    _channels.close();
  }
}
