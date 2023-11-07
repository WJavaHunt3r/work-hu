// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$$_UserModelFromJson(Map<String, dynamic> json) => _$_UserModel(
      id: json['id'] as num,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      team: json['team'] == null
          ? null
          : TeamModel.fromJson(json['team'] as Map<String, dynamic>),
      role: $enumDecode(_$RoleEnumMap, json['role']),
      myShareID: json['myShareID'] as num,
      goal: json['goal'] as num,
      baseMyShareCredit: json['baseMyShareCredit'] as num,
      currentMyShareCredit: json['currentMyShareCredit'] as num,
      points: (json['points'] as num).toDouble(),
      changedPassword: json['changedPassword'] as bool,
    );

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'birthDate': instance.birthDate.toIso8601String(),
      'team': instance.team,
      'role': _$RoleEnumMap[instance.role]!,
      'myShareID': instance.myShareID,
      'goal': instance.goal,
      'baseMyShareCredit': instance.baseMyShareCredit,
      'currentMyShareCredit': instance.currentMyShareCredit,
      'points': instance.points,
      'changedPassword': instance.changedPassword,
    };

const _$RoleEnumMap = {
  Role.USER: 'USER',
  Role.TEAM_LEADER: 'TEAM_LEADER',
  Role.ADMIN: 'ADMIN',
};
