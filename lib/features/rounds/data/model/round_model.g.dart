// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RoundModel _$$_RoundModelFromJson(Map<String, dynamic> json) =>
    _$_RoundModel(
      id: json['id'] as num,
      startDateTime: DateTime.parse(json['startDateTime'] as String),
      endDateTime: DateTime.parse(json['endDateTime'] as String),
      myShareGoal: json['myShareGoal'] as num,
      samvirkGoal: json['samvirkGoal'] as num,
      samvirkChurchGoal: json['samvirkChurchGoal'] as num,
      roundNumber: json['roundNumber'] as num,
    );

Map<String, dynamic> _$$_RoundModelToJson(_$_RoundModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDateTime': instance.startDateTime.toIso8601String(),
      'endDateTime': instance.endDateTime.toIso8601String(),
      'myShareGoal': instance.myShareGoal,
      'samvirkGoal': instance.samvirkGoal,
      'samvirkChurchGoal': instance.samvirkChurchGoal,
      'roundNumber': instance.roundNumber,
    };
