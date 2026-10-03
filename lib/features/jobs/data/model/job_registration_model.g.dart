// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobRegistrationModel _$JobRegistrationModelFromJson(Map<String, dynamic> json) => _JobRegistrationModel(
  id: json['id'] as num?,
  jobId: json['jobId'] as num,
  userId: json['userId'] as num,
  userName: json['userName'] as String?,
  registeredById: json['registeredById'] as num?,
  registeredByName: json['registeredByName'] as String?,
  comment: json['comment'] as String?,
  status: $enumDecode(_$JobRegistrationStatusEnumMap, json['status']),
  waitlistPosition: (json['waitlistPosition'] as num?)?.toInt(),
  registeredDateTime: json['registeredDateTime'] == null ? null : DateTime.parse(json['registeredDateTime'] as String),
  cancelledDateTime: json['cancelledDateTime'] == null ? null : DateTime.parse(json['cancelledDateTime'] as String),
  hours: (json['hours'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$JobRegistrationModelToJson(_JobRegistrationModel instance) => <String, dynamic>{
  'id': instance.id,
  'jobId': instance.jobId,
  'userId': instance.userId,
  'userName': instance.userName,
  'registeredById': instance.registeredById,
  'registeredByName': instance.registeredByName,
  'comment': instance.comment,
  'status': _$JobRegistrationStatusEnumMap[instance.status]!,
  'waitlistPosition': instance.waitlistPosition,
  'registeredDateTime': instance.registeredDateTime?.toIso8601String(),
  'cancelledDateTime': instance.cancelledDateTime?.toIso8601String(),
  'hours': instance.hours,
};

const _$JobRegistrationStatusEnumMap = {
  JobRegistrationStatus.REGISTERED: 'REGISTERED',
  JobRegistrationStatus.WAITLISTED: 'WAITLISTED',
  JobRegistrationStatus.CANCELLED: 'CANCELLED',
};
