import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_api_model.freezed.dart';
part 'workspace_api_model.g.dart';

/// Wire format of `GET /workspace-services/workspaces/me`: a bare JSON array
/// of camelCase objects. Unread counts are not part of it — they come from the
/// chat service on their own endpoint.
@freezed
abstract class WorkspaceApiModel with _$WorkspaceApiModel {
  const factory WorkspaceApiModel({
    required String id,
    required String name,
    @Default(true) bool isActive,
  }) = _WorkspaceApiModel;

  factory WorkspaceApiModel.fromJson(Map<String, Object?> json) =>
      _$WorkspaceApiModelFromJson(json);
}
