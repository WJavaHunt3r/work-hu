import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';

part 'user_round_head_model.freezed.dart';

part 'user_round_head_model.g.dart';

@freezed
class UserRoundHeadModel with _$UserRoundHeadModel {
  const factory UserRoundHeadModel(
      {required int onTrackCount,
      required int goalCount,
      required int churchGoal,
      required int toOnTrackCount}) = _UserRoundHeadModel;

  factory UserRoundHeadModel.fromJson(Map<String, dynamic> json) => _$UserRoundHeadModelFromJson(json);
}
