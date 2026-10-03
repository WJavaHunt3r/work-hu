// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_recurrence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobRecurrenceModel _$JobRecurrenceModelFromJson(Map<String, dynamic> json) => _JobRecurrenceModel(
  daysOfWeek: (json['daysOfWeek'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  repeatUntil: DateTime.parse(json['repeatUntil'] as String),
);

Map<String, dynamic> _$JobRecurrenceModelToJson(_JobRecurrenceModel instance) => <String, dynamic>{
  'daysOfWeek': instance.daysOfWeek,
  'repeatUntil': _dateOnly(instance.repeatUntil),
};
