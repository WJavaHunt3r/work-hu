import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/models/permission.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/roles/data/api/roles_api.dart';
import 'package:work_hu/features/roles/data/model/app_role_model.dart';

class RolesRepository {
  RolesRepository(this._api);

  final RolesApi _api;

  /// The roles endpoint isn't paged, so everything comes back as one page.
  Future<PaginatedResponse<AppRoleModel>> getRoles() => guardApi(() async {
    final res = await _api.getRoles();
    return PaginatedResponse.all(res.map((e) => AppRoleModel.fromJson(e as Map<String, dynamic>)).toList());
  });

  /// Names of every permission the backend knows; falls back to the ones this app knows.
  Future<List<String>> getPermissions() async {
    try {
      final res = await _api.getPermissions();
      return res.map((e) => e.toString()).toList();
    } catch (_) {
      return Permission.values.map((e) => e.name).toList();
    }
  }

  Future<AppRoleModel> saveRole(AppRoleModel role) => guardApi(() async {
    final res = role.id == null ? await _api.postRole(role) : await _api.putRole(role);
    return AppRoleModel.fromJson(res);
  });

  Future<String> deleteRole(num id) => guardApi(() async => (await _api.deleteRole(id)).toString());

  Future<UserModel> setUserRoles(num userId, Iterable<num> roleIds) => guardApi(() async {
    final res = await _api.putUserRoles(userId, roleIds);
    return UserModel.fromJson(res);
  });
}
