import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/roles/data/model/app_role_model.dart';

class RolesApi {
  final DioClient _dioClient = locator<DioClient>();

  Future<List<dynamic>> getRoles() async {
    final res = await _dioClient.dio.get("/roles");
    return res.data;
  }

  Future<List<dynamic>> getPermissions() async {
    final res = await _dioClient.dio.get("/roles/permissions");
    return res.data;
  }

  Future<dynamic> postRole(AppRoleModel role) async {
    final res = await _dioClient.dio.post("/roles", data: role.toJson());
    return res.data;
  }

  Future<dynamic> putRole(AppRoleModel role) async {
    final res = await _dioClient.dio.put("/roles/${role.id}", data: role.toJson());
    return res.data;
  }

  Future<dynamic> deleteRole(num id) async {
    final res = await _dioClient.dio.delete("/roles/$id");
    return res.data;
  }

  /// Replaces all roles of a user; the backend falls back to the default role when [roleIds] is empty.
  Future<dynamic> putUserRoles(num userId, Iterable<num> roleIds) async {
    final res = await _dioClient.dio.put("/user/$userId/roles", data: roleIds.toList());
    return res.data;
  }
}
