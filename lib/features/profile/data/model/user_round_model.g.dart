// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_round_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserRoundModel _$$_UserRoundModelFromJson(Map<String, dynamic> json) =>
    _$_UserRoundModel(
      round: RoundModel.fromJson(json['round'] as Map<String, dynamic>),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      myShareOnTrackPoints: json['myShareOnTrackPoints'] as bool,
      samvirkOnTrackPoints: json['samvirkOnTrackPoints'] as bool,
      samvirkPayments: json['samvirkPayments'] as int,
      forbildePoints: (json['forbildePoints'] as num).toDouble(),
      samvirkPoints: (json['samvirkPoints'] as num).toDouble(),
      roundPoints: (json['roundPoints'] as num).toDouble(),
    );

Map<String, dynamic> _$$_UserRoundModelToJson(_$_UserRoundModel instance) =>
    <String, dynamic>{
      'round': instance.round,
      'user': instance.user,
      'myShareOnTrackPoints': instance.myShareOnTrackPoints,
      'samvirkOnTrackPoints': instance.samvirkOnTrackPoints,
      'samvirkPayments': instance.samvirkPayments,
      'forbildePoints': instance.forbildePoints,
      'samvirkPoints': instance.samvirkPoints,
      'roundPoints': instance.roundPoints,
    };
