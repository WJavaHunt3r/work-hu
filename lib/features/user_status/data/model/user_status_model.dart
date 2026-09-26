import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';

part 'user_status_model.freezed.dart';

part 'user_status_model.g.dart';

@freezed
abstract class UserStatusModel with _$UserStatusModel {
  const factory UserStatusModel(
      {required num id,
      required String name,
      required num userId,
      required num goal,
      required num status,
      required num transactions,
      required num transition,
      required bool onTrack,
      required bool localOnTrack,
      required num toOnTrack,
      required num toLocalOnTrack,
      required num seasonYear}) = _UserStatusModel;

  factory UserStatusModel.fromJson(Map<String, dynamic> json) => _$UserStatusModelFromJson(json);
}
