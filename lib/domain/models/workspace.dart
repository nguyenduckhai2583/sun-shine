import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace.freezed.dart';

@freezed
abstract class Workspace with _$Workspace {
  const Workspace._();

  const factory Workspace({
    required String id,
    required String name,
    @Default(0) int unreadCount,
  }) = _Workspace;

  String get initial => name.isEmpty ? '?' : name.substring(0, 1).toUpperCase();
}
