import 'package:work_hu/features/home/data/model/team_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/users/data/api/users_api.dart';

class UsersRepository {
  final UsersApi _userApi;

  UsersRepository(this._userApi);

  Future<List<UserModel>> getUsers([TeamModel? teamModel, bool? listO36]) async {
    try {
      final res = await _userApi.getUsers(teamModel, listO36);
      var map = res.map((e) => UserModel.fromJson(e)).toList();
      return map;
    } catch (e) {
      rethrow;
    }
  }
}
