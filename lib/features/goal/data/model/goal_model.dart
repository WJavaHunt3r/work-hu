import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_model.freezed.dart';
part 'goal_model.g.dart';

@freezed
abstract class GoalModel with _$GoalModel {
  const factory GoalModel({num? id, required num goal, String? username, num? seasonYear, num? userId}) = _GoalModel;

  factory GoalModel.fromJson(Map<String, dynamic> json) => _$GoalModelFromJson(json);
}
