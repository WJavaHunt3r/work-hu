import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel(
      {required num id,
      required String firstname,
      required String lastname,
      required DateTime birthDate,
      TeamModel? team,
      required Role role,
      required num myShareID,
      required num baseMyShareCredit,
      required num currentMyShareCredit,
      required bool changedPassword}) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  const UserModel._();

  String getFullName() {
    return "$firstname $lastname";
  }
}
