import 'package:dio/dio.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';
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

  Future<List<UserModel>> getChildren(num id) async {
    try {
      final res = await _userApi.getChildren(id);
      var map = res.map((e) => UserModel.fromJson(e)).toList();
      return map;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUserById(num userId) async {
    try {
      final res = await _userApi.getUserById(userId);
      return UserModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUserByMyShareId(num myShareId) async {
    try {
      final res = await _userApi.getUserByMyShareId(myShareId);
      return UserModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> resetPassword(num userId, num changerId) async {
    try {
      final res = await _userApi.resetPassword(userId, changerId);
      return res;
    } on DioException {
      rethrow;
    }
  }

  Future<UserModel> updateUser(num userId, UserModel user) async {
    try {
      final res = await _userApi.updateUser(userId, user);
      return UserModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }
}
