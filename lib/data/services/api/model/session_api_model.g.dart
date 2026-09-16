// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionApiModel _$SessionApiModelFromJson(Map<String, dynamic> json) =>
    _SessionApiModel(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      accessToken: json['access_token'] as String,
    );

Map<String, dynamic> _$SessionApiModelToJson(_SessionApiModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'access_token': instance.accessToken,
    };
