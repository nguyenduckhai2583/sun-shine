// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChannelUpdateRequest _$ChannelUpdateRequestFromJson(
  Map<String, dynamic> json,
) => _ChannelUpdateRequest(
  name: json['name'] as String?,
  isPrivate: json['isPrivate'] as bool?,
);

Map<String, dynamic> _$ChannelUpdateRequestToJson(
  _ChannelUpdateRequest instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'isPrivate': ?instance.isPrivate,
};
