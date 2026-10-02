import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/role.dart';

part 'app_role_model.freezed.dart';
part 'app_role_model.g.dart';

/// A named bundle of permissions that can be assigned to users. A user's effective permissions are the union over
/// all of their roles.
@freezed
abstract class AppRoleModel with _$AppRoleModel {
  const factory AppRoleModel({
    num? id,
    required String name,
    String? description,

    /// Permission names; strings so permissions unknown to this app version survive an edit.
    @Default([]) List<String> permissions,
    @Default(0) num userCount,
  }) = _AppRoleModel;

  factory AppRoleModel.fromJson(Map<String, dynamic> json) => _$AppRoleModelFromJson(json);

  const AppRoleModel._();

  /// The roles the backend creates itself: they can't be renamed or deleted.
  bool get isBuiltIn => Role.values.any((r) => r.name == name);

  /// The ADMIN role is fixed and always holds every permission.
  bool get isAdminRole => name == Role.ADMIN.name;
}
