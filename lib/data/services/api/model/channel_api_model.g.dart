// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChannelApiModel _$ChannelApiModelFromJson(Map<String, dynamic> json) =>
    _ChannelApiModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      isPrivate: json['isPrivate'] as bool? ?? false,
      isEncrypted: json['isEncrypted'] as bool? ?? false,
    );

Map<String, dynamic> _$ChannelApiModelToJson(_ChannelApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isPrivate': instance.isPrivate,
      'isEncrypted': instance.isEncrypted,
    };
