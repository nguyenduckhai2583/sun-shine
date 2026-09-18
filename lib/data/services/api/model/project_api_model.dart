import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_api_model.freezed.dart';
part 'project_api_model.g.dart';

@freezed
abstract class ProjectApiModel with _$ProjectApiModel {
  const factory ProjectApiModel({
    required String id,
    required String name,
    required String key,
    @JsonKey(name: 'open_tasks') @Default(0) int openTasks,
  }) = _ProjectApiModel;

  factory ProjectApiModel.fromJson(Map<String, Object?> json) =>
      _$ProjectApiModelFromJson(json);
}
