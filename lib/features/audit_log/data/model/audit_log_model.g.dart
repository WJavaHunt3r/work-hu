// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditLogModel _$AuditLogModelFromJson(Map<String, dynamic> json) =>
    _AuditLogModel(
      id: json['id'] as num,
      timestamp: DateTime.parse(json['timestamp'] as String),
      action: json['action'] as String,
      entityType: json['entityType'] as String?,
      entityId: json['entityId'] as String?,
      userId: json['userId'] as num?,
      username: json['username'] as String?,
      ipAddress: json['ipAddress'] as String?,
      request: json['request'] as String?,
      details: json['details'],
    );

Map<String, dynamic> _$AuditLogModelToJson(_AuditLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'action': instance.action,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'userId': instance.userId,
      'username': instance.username,
      'ipAddress': instance.ipAddress,
      'request': instance.request,
      'details': instance.details,
    };
