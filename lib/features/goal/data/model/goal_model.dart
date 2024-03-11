import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';

part 'goal_model.freezed.dart';
part 'goal_model.g.dart';

@freezed
class GoalModel with _$GoalModel {
  const factory GoalModel({
    num? id,
    required num goal,
    UserModel? user,
    SeasonModel? season
  }) = _GoalModel;

  factory GoalModel.fromJson(Map<String, dynamic> json) => _$GoalModelFromJson(json);
}