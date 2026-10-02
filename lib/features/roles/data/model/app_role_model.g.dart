// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppRoleModel _$AppRoleModelFromJson(Map<String, dynamic> json) =>
    _AppRoleModel(
      id: json['id'] as num?,
      name: json['name'] as String,
      description: json['description'] as String?,
      permissions:
          (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      userCount: json['userCount'] as num? ?? 0,
    );

Map<String, dynamic> _$AppRoleModelToJson(_AppRoleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'permissions': instance.permissions,
      'userCount': instance.userCount,
    };
