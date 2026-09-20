import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_api_model.dart';

part 'session_api_model.freezed.dart';
part 'session_api_model.g.dart';

@freezed
abstract class SessionApiModel with _$SessionApiModel {
  const factory SessionApiModel({
    required String token,
    String? refreshToken,
    int? expireAt,
    bool? isTmpToken,
    UserApiModel? user,
  }) = _SessionApiModel;

  factory SessionApiModel.fromJson(Map<String, dynamic> json) =>
      _$SessionApiModelFromJson(json);
}
