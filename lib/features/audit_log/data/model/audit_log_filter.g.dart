// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditLogFilter _$AuditLogFilterFromJson(Map<String, dynamic> json) =>
    _AuditLogFilter(
      action: json['action'] as String?,
      entityType: json['entityType'] as String?,
      username: json['username'] as String?,
      dateFrom: json['dateFrom'] == null
          ? null
          : DateTime.parse(json['dateFrom'] as String),
      dateTo: json['dateTo'] == null
          ? null
          : DateTime.parse(json['dateTo'] as String),
      searchText: json['searchText'] as String?,
    );

Map<String, dynamic> _$AuditLogFilterToJson(_AuditLogFilter instance) =>
    <String, dynamic>{
      'action': instance.action,
      'entityType': instance.entityType,
      'username': instance.username,
      'dateFrom': instance.dateFrom?.toIso8601String(),
      'dateTo': instance.dateTo?.toIso8601String(),
      'searchText': instance.searchText,
    };
