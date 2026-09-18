// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectApiModel _$ProjectApiModelFromJson(Map<String, dynamic> json) =>
    _ProjectApiModel(
      id: json['id'] as String,
      name: json['name'] as String,
      key: json['key'] as String,
      openTasks: (json['open_tasks'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProjectApiModelToJson(_ProjectApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'key': instance.key,
      'open_tasks': instance.openTasks,
    };
