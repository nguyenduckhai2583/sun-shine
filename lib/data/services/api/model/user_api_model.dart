import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_api_model.freezed.dart';
part 'user_api_model.g.dart';

@freezed
abstract class UserApiModel with _$UserApiModel {
  const factory UserApiModel({
    required String id,
    required String email,
    String? firstName,
    String? lastName,

    /// The wire sends a whole file object here; the app only wants its url.
    @JsonKey(fromJson: _avatarFromJson, toJson: _avatarToJson) String? avatar,
  }) = _UserApiModel;

  const UserApiModel._();

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  /// The api has no full name of its own; it is the family name first, the
  /// way the employer app renders it.
  String? get displayName {
    final parts = [
      ?lastName,
      ?firstName,
    ].where((part) => part.trim().isNotEmpty);
    return parts.isEmpty ? null : parts.join(' ');
  }
}

String? _avatarFromJson(Map<String, dynamic>? json) =>
    json?['signedUrl'] as String?;

Map<String, dynamic>? _avatarToJson(String? url) =>
    url == null ? null : <String, dynamic>{'signedUrl': url};
