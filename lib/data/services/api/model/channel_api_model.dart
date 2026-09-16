import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel_api_model.freezed.dart';
part 'channel_api_model.g.dart';

@freezed
abstract class ChannelApiModel with _$ChannelApiModel {
  const factory ChannelApiModel({
    required String id,
    required String name,
    @Default('') String topic,
    @JsonKey(name: 'member_count') @Default(0) int memberCount,
  }) = _ChannelApiModel;

  factory ChannelApiModel.fromJson(Map<String, Object?> json) =>
      _$ChannelApiModelFromJson(json);
}
