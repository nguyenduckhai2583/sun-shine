import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_api_model.freezed.dart';
part 'workspace_api_model.g.dart';

@freezed
abstract class WorkspaceApiModel with _$WorkspaceApiModel {
  const factory WorkspaceApiModel({
    required String id,
    required String name,
    @JsonKey(name: 'badge_count') @Default(0) int badgeCount,
  }) = _WorkspaceApiModel;

  factory WorkspaceApiModel.fromJson(Map<String, Object?> json) =>
      _$WorkspaceApiModelFromJson(json);
}
