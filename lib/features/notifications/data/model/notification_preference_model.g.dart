// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPreferenceModel _$NotificationPreferenceModelFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferenceModel(
  type: json['type'] as String,
  channel: json['channel'] as String?,
  enabled: json['enabled'] as bool? ?? true,
);

Map<String, dynamic> _$NotificationPreferenceModelToJson(
  _NotificationPreferenceModel instance,
) => <String, dynamic>{
  'type': instance.type,
  'channel': instance.channel,
  'enabled': instance.enabled,
};
