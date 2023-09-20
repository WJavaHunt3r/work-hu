// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TeamModel _$$_TeamModelFromJson(Map<String, dynamic> json) => _$_TeamModel(
      id: json['id'] as num,
      teamLeaderMyShareId: json['teamLeaderMyShareId'] as num,
      color: json['color'] as String,
      points: (json['points'] as num).toDouble(),
    );

Map<String, dynamic> _$$_TeamModelToJson(_$_TeamModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamLeaderMyShareId': instance.teamLeaderMyShareId,
      'color': instance.color,
      'points': instance.points,
    };
