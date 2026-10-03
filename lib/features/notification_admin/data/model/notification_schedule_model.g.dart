// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationScheduleModel _$NotificationScheduleModelFromJson(Map<String, dynamic> json) => _NotificationScheduleModel(
  id: json['id'] as num?,
  type: json['type'] as String? ?? 'WEEKLY',
  title: json['title'] as String?,
  body: json['body'] as String?,
  dayOfWeek: json['dayOfWeek'] as String? ?? 'MONDAY',
  time: json['time'] as String? ?? '17:00',
  active: json['active'] as bool? ?? true,
  roleIds: (json['roleIds'] as List<dynamic>?)?.map((e) => e as num).toList() ?? const [],
  lastSentDateTime: json['lastSentDateTime'] == null ? null : DateTime.parse(json['lastSentDateTime'] as String),
);

Map<String, dynamic> _$NotificationScheduleModelToJson(_NotificationScheduleModel instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'body': instance.body,
  'dayOfWeek': instance.dayOfWeek,
  'time': instance.time,
  'active': instance.active,
  'roleIds': instance.roleIds,
  'lastSentDateTime': instance.lastSentDateTime?.toIso8601String(),
};
