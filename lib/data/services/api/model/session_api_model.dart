import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_api_model.freezed.dart';
part 'session_api_model.g.dart';

@freezed
abstract class SessionApiModel with _$SessionApiModel {
  const factory SessionApiModel({
    @JsonKey(name: 'user_id') required String userId,
    required String email,
    @JsonKey(name: 'access_token') required String accessToken,
  }) = _SessionApiModel;

  factory SessionApiModel.fromJson(Map<String, Object?> json) =>
      _$SessionApiModelFromJson(json);
}
