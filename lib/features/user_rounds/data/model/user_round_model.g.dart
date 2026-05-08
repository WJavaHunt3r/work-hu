// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_round_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserRoundModelImpl _$$UserRoundModelImplFromJson(Map<String, dynamic> json) =>
    _$UserRoundModelImpl(
      round: RoundModel.fromJson(json['round'] as Map<String, dynamic>),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      samvirkPayments: (json['samvirkPayments'] as num).toInt(),
      bmmperfectWeekPoints: (json['bmmperfectWeekPoints'] as num?)?.toDouble(),
      roundCoins: json['roundCoins'] as num,
      roundCredits: json['roundCredits'] as num,
      roundMyShareGoal: json['roundMyShareGoal'] as num,
    );

Map<String, dynamic> _$$UserRoundModelImplToJson(
        _$UserRoundModelImpl instance) =>
    <String, dynamic>{
      'round': instance.round,
      'user': instance.user,
      'samvirkPayments': instance.samvirkPayments,
      'bmmperfectWeekPoints': instance.bmmperfectWeekPoints,
      'roundCoins': instance.roundCoins,
      'roundCredits': instance.roundCredits,
      'roundMyShareGoal': instance.roundMyShareGoal,
    };
