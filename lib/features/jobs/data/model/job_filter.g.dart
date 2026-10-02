// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobFilter _$JobFilterFromJson(Map<String, dynamic> json) => _JobFilter(
  status: $enumDecodeNullable(_$JobStatusEnumMap, json['status']),
  openOnly: json['openOnly'] as bool? ?? false,
  onlyMine: json['onlyMine'] as bool? ?? false,
  dateFrom: json['dateFrom'] == null
      ? null
      : DateTime.parse(json['dateFrom'] as String),
  dateTo: json['dateTo'] == null
      ? null
      : DateTime.parse(json['dateTo'] as String),
  searchText: json['searchText'] as String?,
);

Map<String, dynamic> _$JobFilterToJson(_JobFilter instance) =>
    <String, dynamic>{
      'status': _$JobStatusEnumMap[instance.status],
      'openOnly': instance.openOnly,
      'onlyMine': instance.onlyMine,
      'dateFrom': instance.dateFrom?.toIso8601String(),
      'dateTo': instance.dateTo?.toIso8601String(),
      'searchText': instance.searchText,
    };

const _$JobStatusEnumMap = {
  JobStatus.OPEN: 'OPEN',
  JobStatus.COMPLETED: 'COMPLETED',
  JobStatus.CANCELLED: 'CANCELLED',
};
