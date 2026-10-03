// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeneralNotificationModel _$GeneralNotificationModelFromJson(Map<String, dynamic> json) => _GeneralNotificationModel(
  id: json['id'] as num?,
  title: json['title'] as String,
  body: json['body'] as String,
  roleIds: (json['roleIds'] as List<dynamic>?)?.map((e) => e as num).toList() ?? const [],
  sentByName: json['sentByName'] as String?,
  sentDateTime: json['sentDateTime'] == null ? null : DateTime.parse(json['sentDateTime'] as String),
  recipientUsers: (json['recipientUsers'] as num?)?.toInt() ?? 0,
  delivered: (json['delivered'] as num?)?.toInt() ?? 0,
  failed: (json['failed'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$GeneralNotificationModelToJson(_GeneralNotificationModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'roleIds': instance.roleIds,
  'sentByName': instance.sentByName,
  'sentDateTime': instance.sentDateTime?.toIso8601String(),
  'recipientUsers': instance.recipientUsers,
  'delivered': instance.delivered,
  'failed': instance.failed,
};
