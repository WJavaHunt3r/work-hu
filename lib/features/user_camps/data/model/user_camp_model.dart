import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/features/camps/data/model/camp_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

part 'user_camp_model.freezed.dart';

part 'user_camp_model.g.dart';

@freezed
class UserCampModel with _$UserCampModel {
  const factory UserCampModel({
    num? id,
    required UserModel userModel,
    required CampModel campModel,
    required num price,
    required bool participates,
  }) = _CampModel;

  factory UserCampModel.fromJson(Map<String, dynamic> json) => _$UserCampModelFromJson(json);
}
