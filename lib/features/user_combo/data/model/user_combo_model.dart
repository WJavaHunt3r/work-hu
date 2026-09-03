import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';

part 'user_combo_model.freezed.dart';

part 'user_combo_model.g.dart';

@freezed
class UserComboModel with _$UserComboModel {
  const factory UserComboModel(
      {required num id,
        required String firstname,
        required String lastname,
        required int age,
        required String comboText,
        required String churchName,
        }) = _UserComboModel;

  factory UserComboModel.fromJson(Map<String, dynamic> json) =>
      _$UserComboModelFromJson(json);

  const UserComboModel._();

  String getFullName() {
    return "$lastname $firstname";
  }

}
