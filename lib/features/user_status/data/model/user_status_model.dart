import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';

part 'user_status_model.freezed.dart';

part 'user_status_model.g.dart';

@freezed
class UserStatusModel with _$UserStatusModel {
  const factory UserStatusModel(
      {required num id,
      required UserModel user,
      required num goal,
      required num status,
      required num transactions,
      required num transition,
      required bool onTrack,
      required SeasonModel season}) = _UserStatusModel;

  factory UserStatusModel.fromJson(Map<String, dynamic> json) =>
      _$UserStatusModelFromJson(json);
}
