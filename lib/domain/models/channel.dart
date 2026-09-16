import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel.freezed.dart';

@freezed
abstract class Channel with _$Channel {
  const Channel._();

  const factory Channel({
    required String id,
    required String name,
    @Default('') String topic,
    @Default(0) int memberCount,
  }) = _Channel;

  String get displayName => '#$name';
}
