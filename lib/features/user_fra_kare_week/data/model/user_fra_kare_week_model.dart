import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/fra_kare_week/data/model/fra_kare_week_model.dart';

import '../../../login/data/model/user_model.dart';

part 'user_fra_kare_week_model.freezed.dart';

part 'user_fra_kare_week_model.g.dart';

@freezed
class UserFraKareWeekModel with _$UserFraKareWeekModel {
  const factory UserFraKareWeekModel(
      {required num id,
      required UserModel user,
      required FraKareWeekModel fraKareWeek,
      required bool listened}) = _UserFraKareWeekModel;

  factory UserFraKareWeekModel.fromJson(Map<String, dynamic> json) => _$UserFraKareWeekModelFromJson(json);
}
