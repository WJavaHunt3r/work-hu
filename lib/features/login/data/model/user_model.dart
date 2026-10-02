import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/gender.dart';
import 'package:work_hu/app/models/permission.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required num id,
    required String firstname,
    required String lastname,
    DateTime? birthDate,
    TeamModel? paceTeam,

    /// Legacy single role, derived by the backend. Unknown values fall back to USER.
    @JsonKey(unknownEnumValue: Role.USER) required Role role,

    /// Names of all roles of the user; change them with `PUT /user/{id}/roles`.
    @Default([]) List<String> roleNames,

    /// Effective permissions (union over all roles), as names so unknown ones don't break parsing.
    @Default([]) List<String> permissions,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) Gender? gender,
    num? myShareID,
    num? baseMyShareCredit,
    num? currentMyShareCredit,
    required bool changedPassword,
    num? familyId,
    num? spouseId,
    num? phoneNumber,
    num? bufeId,
    num? points,
    String? email,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  const UserModel._();

  String getFullName() {
    return "$lastname $firstname";
  }

  num getAge() {
    if (birthDate == null) {
      return 0;
    }
    return (DateTime.now().difference(birthDate!).inDays / 365).ceil() - 1;
  }

  bool isMentor() {
    return getAge() > 18;
  }

  bool hasPermission(Permission permission) => permissions.contains(permission.name);

  bool hasAnyPermission(Iterable<Permission> any) => any.any(hasPermission);

  /// Admins only by role; prefer [hasPermission] for features that have a permission.
  bool isAdmin() {
    return role == Role.ADMIN;
  }

  /// Whether the admin tab has anything to show: team leaders, admins and anyone holding a management permission.
  bool hasAdminAccess() =>
      isAdmin() ||
      isTeamLeader() ||
      hasAnyPermission(const [
        Permission.USER_MANAGE,
        Permission.ROLE_MANAGE,
        Permission.TRANSACTION_MANAGE,
        Permission.GOAL_MANAGE,
        Permission.MENTOR_MANAGE,
        Permission.CAMP_MANAGE,
        Permission.DONATION_MANAGE,
        Permission.PAYMENT_MANAGE,
        Permission.SEASON_MANAGE,
      ]);

  /// A parent is an adult with a family; their children are the family members aged 18 or younger.
  bool isAdult() => getAge() > 18;

  bool isTeamLeader() {
    return role == Role.TEAM_LEADER;
  }

  bool isUser() {
    return role == Role.USER;
  }
}
