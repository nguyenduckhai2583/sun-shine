// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionApiModel _$SessionApiModelFromJson(Map<String, dynamic> json) =>
    _SessionApiModel(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      expireAt: (json['expireAt'] as num?)?.toInt(),
      isTmpToken: json['isTmpToken'] as bool?,
      user: json['user'] == null
          ? null
          : UserApiModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionApiModelToJson(_SessionApiModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'expireAt': instance.expireAt,
      'isTmpToken': instance.isTmpToken,
      'user': instance.user,
    };
