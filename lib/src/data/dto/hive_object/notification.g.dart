// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      type: $enumDecodeNullable(_$NotificationTypeEnumMap, json['type']),
      createAt: json['createAt'],
      title: json['title'] as String?,
      desc: json['desc'] as String?,
      payload: json['payload'] as Map<String, dynamic>?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$NotificationTypeEnumMap[instance.type],
      'title': instance.title,
      'desc': instance.desc,
      'createAt': instance.createAt,
      'payload': instance.payload,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.storeInvite: 'storeInvite',
  NotificationType.undefined: 'undefined',
};
