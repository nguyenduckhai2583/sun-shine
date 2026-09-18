import 'package:sun_shine/core.dart';

class ChannelNotFoundException implements Exception {
  const ChannelNotFoundException(this.channelId);

  final String channelId;

  @override
  String toString() => 'ChannelNotFoundException($channelId)';
}

class InvalidChannelNameException implements Exception {
  const InvalidChannelNameException(this.name);

  final String name;

  @override
  String toString() => 'InvalidChannelNameException($name)';
}

class ChannelApiClient extends BaseApiClient {
  final _channels = <Map<String, Object>>[
    {
      'id': 'general',
      'name': 'general',
      'topic': 'Company-wide announcements',
      'member_count': 128,
    },
    {
      'id': 'engineering',
      'name': 'engineering',
      'topic': 'Builds, reviews, incidents',
      'member_count': 42,
    },
    {
      'id': 'design',
      'name': 'design',
      'topic': 'Specs, critique, design system',
      'member_count': 17,
    },
    {
      'id': 'random',
      'name': 'random',
      'topic': 'Anything goes',
      'member_count': 96,
    },
  ];

  Future<Result<List<ChannelApiModel>>> getChannels() async {
    try {
      return Result.ok(_channels.map(ChannelApiModel.fromJson).toList());
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<ChannelApiModel>> getChannel(String channelId) async {
    try {
      final index = _indexOf(channelId);
      if (index < 0) return Result.error(ChannelNotFoundException(channelId));
      return Result.ok(ChannelApiModel.fromJson(_channels[index]));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<ChannelApiModel>> updateChannelName(
    String channelId,
    String name,
  ) async {
    try {
      final trimmed = name.trim();
      if (trimmed.isEmpty || trimmed.contains(' ')) {
        return Result.error(InvalidChannelNameException(name));
      }
      final index = _indexOf(channelId);
      if (index < 0) return Result.error(ChannelNotFoundException(channelId));

      _channels[index] = {..._channels[index], 'name': trimmed};
      return Result.ok(ChannelApiModel.fromJson(_channels[index]));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  int _indexOf(String channelId) =>
      _channels.indexWhere((channel) => channel['id'] == channelId);
}
