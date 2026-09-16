// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkspaceApiModel _$WorkspaceApiModelFromJson(Map<String, dynamic> json) =>
    _WorkspaceApiModel(
      id: json['id'] as String,
      name: json['name'] as String,
      badgeCount: (json['badge_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$WorkspaceApiModelToJson(_WorkspaceApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'badge_count': instance.badgeCount,
    };
