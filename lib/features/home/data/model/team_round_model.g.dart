// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_round_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TeamRoundModel _$$_TeamRoundModelFromJson(Map<String, dynamic> json) =>
    _$_TeamRoundModel(
      id: json['id'] as num,
      round: RoundModel.fromJson(json['round'] as Map<String, dynamic>),
      team: TeamModel.fromJson(json['team'] as Map<String, dynamic>),
      teamPoints: (json['teamPoints'] as num).toDouble(),
      samvirkPayments: (json['samvirkPayments'] as num).toDouble(),
    );

Map<String, dynamic> _$$_TeamRoundModelToJson(_$_TeamRoundModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'round': instance.round,
      'team': instance.team,
      'teamPoints': instance.teamPoints,
      'samvirkPayments': instance.samvirkPayments,
    };
