import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';

@freezed
abstract class Project with _$Project {
  const Project._();

  const factory Project({
    required String id,
    required String name,
    required String key,
    @Default(0) int openTasks,
  }) = _Project;

  String get displayKey => key.toUpperCase();
}
