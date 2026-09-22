import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel_api_model.freezed.dart';
part 'channel_api_model.g.dart';

/// Wire format of `GET /chat-services/channels`. The list is the only source
/// of channel data — the service has no endpoint for a single channel.
@freezed
abstract class ChannelApiModel with _$ChannelApiModel {
  const factory ChannelApiModel({
    required String id,
    String? name,
    @Default(false) bool isPrivate,
    @Default(false) bool isEncrypted,
  }) = _ChannelApiModel;

  factory ChannelApiModel.fromJson(Map<String, Object?> json) =>
      _$ChannelApiModelFromJson(json);
}
