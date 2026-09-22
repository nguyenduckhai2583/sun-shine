import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel_request.freezed.dart';
part 'channel_request.g.dart';

/// Body of `PUT /chat-services/channels/{id}`. Only the fields being changed
/// are sent, so renaming a channel cannot quietly flip its privacy.
@freezed
abstract class ChannelUpdateRequest with _$ChannelUpdateRequest {
  @JsonSerializable(includeIfNull: false)
  const factory ChannelUpdateRequest({String? name, bool? isPrivate}) =
      _ChannelUpdateRequest;

  factory ChannelUpdateRequest.fromJson(Map<String, Object?> json) =>
      _$ChannelUpdateRequestFromJson(json);
}
