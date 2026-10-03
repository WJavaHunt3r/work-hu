// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobModel _$JobModelFromJson(Map<String, dynamic> json) => _JobModel(
  id: json['id'] as num?,
  jobDateTime: DateTime.parse(json['jobDateTime'] as String),
  jobEndDateTime: json['jobEndDateTime'] == null ? null : DateTime.parse(json['jobEndDateTime'] as String),
  description: json['description'] as String,
  employerId: json['employerId'] as num,
  responsibleId: json['responsibleId'] as num,
  account: $enumDecode(_$AccountEnumMap, json['account']),
  transactionType: $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
  registrationOpensAt: json['registrationOpensAt'] == null
      ? null
      : DateTime.parse(json['registrationOpensAt'] as String),
  sendNotification: json['sendNotification'] as bool? ?? true,
  registrationDeadline: json['registrationDeadline'] == null
      ? null
      : DateTime.parse(json['registrationDeadline'] as String),
  cancellationDeadline: json['cancellationDeadline'] == null
      ? null
      : DateTime.parse(json['cancellationDeadline'] as String),
  cancellationAllowed: json['cancellationAllowed'] as bool? ?? true,
  registrationClosed: json['registrationClosed'] as bool? ?? false,
  maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
  waitlistEnabled: json['waitlistEnabled'] as bool? ?? false,
  minAge: (json['minAge'] as num?)?.toInt(),
  maxAge: (json['maxAge'] as num?)?.toInt(),
  genderRestriction: $enumDecodeNullable(
    _$GenderEnumMap,
    json['genderRestriction'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  recurrence: json['recurrence'] == null
      ? null
      : JobRecurrenceModel.fromJson(json['recurrence'] as Map<String, dynamic>),
  seriesId: json['seriesId'] as String?,
  createDateTime: json['createDateTime'] == null ? null : DateTime.parse(json['createDateTime'] as String),
  createUserId: json['createUserId'] as num?,
  createUserName: json['createUserName'] as String?,
  employerName: json['employerName'] as String?,
  responsibleName: json['responsibleName'] as String?,
  status: $enumDecodeNullable(_$JobStatusEnumMap, json['status']) ?? JobStatus.OPEN,
  activityId: json['activityId'] as num?,
  completedDateTime: json['completedDateTime'] == null ? null : DateTime.parse(json['completedDateTime'] as String),
  registeredCount: json['registeredCount'] as num? ?? 0,
  waitlistCount: json['waitlistCount'] as num? ?? 0,
  full: json['full'] as bool? ?? false,
  registrationOpen: json['registrationOpen'] as bool? ?? false,
  cancellationOpen: json['cancellationOpen'] as bool? ?? false,
  myRegistrationStatus: $enumDecodeNullable(_$JobRegistrationStatusEnumMap, json['myRegistrationStatus']),
);

Map<String, dynamic> _$JobModelToJson(_JobModel instance) => <String, dynamic>{
  'id': instance.id,
  'jobDateTime': instance.jobDateTime.toIso8601String(),
  'jobEndDateTime': instance.jobEndDateTime?.toIso8601String(),
  'description': instance.description,
  'employerId': instance.employerId,
  'responsibleId': instance.responsibleId,
  'account': _$AccountEnumMap[instance.account]!,
  'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
  'registrationOpensAt': instance.registrationOpensAt?.toIso8601String(),
  'sendNotification': instance.sendNotification,
  'registrationDeadline': instance.registrationDeadline?.toIso8601String(),
  'cancellationDeadline': instance.cancellationDeadline?.toIso8601String(),
  'cancellationAllowed': instance.cancellationAllowed,
  'registrationClosed': instance.registrationClosed,
  'maxParticipants': instance.maxParticipants,
  'waitlistEnabled': instance.waitlistEnabled,
  'minAge': instance.minAge,
  'maxAge': instance.maxAge,
  'genderRestriction': _$GenderEnumMap[instance.genderRestriction],
  'recurrence': ?instance.recurrence,
  'seriesId': instance.seriesId,
  'createDateTime': instance.createDateTime?.toIso8601String(),
  'createUserId': instance.createUserId,
  'createUserName': instance.createUserName,
  'employerName': instance.employerName,
  'responsibleName': instance.responsibleName,
  'status': _$JobStatusEnumMap[instance.status]!,
  'activityId': instance.activityId,
  'completedDateTime': instance.completedDateTime?.toIso8601String(),
  'registeredCount': instance.registeredCount,
  'waitlistCount': instance.waitlistCount,
  'full': instance.full,
  'registrationOpen': instance.registrationOpen,
  'cancellationOpen': instance.cancellationOpen,
  'myRegistrationStatus': _$JobRegistrationStatusEnumMap[instance.myRegistrationStatus],
};

const _$AccountEnumMap = {Account.SAMVIRK: 'SAMVIRK', Account.MYSHARE: 'MYSHARE', Account.OTHER: 'OTHER'};

const _$TransactionTypeEnumMap = {
  TransactionType.HOURS: 'HOURS',
  TransactionType.CREDIT: 'CREDIT',
  TransactionType.POINT: 'POINT',
  TransactionType.BMM_PERFECT_WEEK: 'BMM_PERFECT_WEEK',
  TransactionType.VAER_ET_FORBILDE: 'VAER_ET_FORBILDE',
  TransactionType.DUKA_MUNKA: 'DUKA_MUNKA',
  TransactionType.DUKA_MUNKA_2000: 'DUKA_MUNKA_2000',
};

const _$GenderEnumMap = {Gender.MALE: 'MALE', Gender.FEMALE: 'FEMALE'};

const _$JobStatusEnumMap = {JobStatus.OPEN: 'OPEN', JobStatus.COMPLETED: 'COMPLETED', JobStatus.CANCELLED: 'CANCELLED'};

const _$JobRegistrationStatusEnumMap = {
  JobRegistrationStatus.REGISTERED: 'REGISTERED',
  JobRegistrationStatus.WAITLISTED: 'WAITLISTED',
  JobRegistrationStatus.CANCELLED: 'CANCELLED',
};
