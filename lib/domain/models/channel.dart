import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel.freezed.dart';

@freezed
abstract class Channel with _$Channel {
  const Channel._();

  const factory Channel({
    required String id,
    required String name,
    @Default(false) bool isPrivate,
    @Default(false) bool isEncrypted,
  }) = _Channel;

  String get displayName => '#$name';
}
