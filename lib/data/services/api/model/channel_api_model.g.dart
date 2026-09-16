// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChannelApiModel _$ChannelApiModelFromJson(Map<String, dynamic> json) =>
    _ChannelApiModel(
      id: json['id'] as String,
      name: json['name'] as String,
      topic: json['topic'] as String? ?? '',
      memberCount: (json['member_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ChannelApiModelToJson(_ChannelApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'topic': instance.topic,
      'member_count': instance.memberCount,
    };
