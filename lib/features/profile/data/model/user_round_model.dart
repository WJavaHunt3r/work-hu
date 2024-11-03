import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';

part 'user_round_model.freezed.dart';

part 'user_round_model.g.dart';

@freezed
class UserRoundModel with _$UserRoundModel {
  const factory UserRoundModel({
    required RoundModel round,
    required UserModel user,
    required int samvirkPayments,
    required double bmmperfectWeekPoints,
    required num roundCoins,
    required num roundCredits,
    required num roundMyShareGoal,
  }) = _UserRoundModel;

  factory UserRoundModel.fromJson(Map<String, dynamic> json) => _$UserRoundModelFromJson(json);
}
