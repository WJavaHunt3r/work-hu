import 'package:dio/dio.dart';

import '../api/user_status_api.dart';
import '../model/user_status_model.dart';

class UserStatusRepository {
  final UserStatusApi _userStatusApi;

  UserStatusRepository(this._userStatusApi);

  Future<List<UserStatusModel>> getUserStatuses(
      num seasonYear, num? teamId) async {
    try {
      final res = await _userStatusApi.getUserStatuses(seasonYear, teamId);
      return res.map((e) => UserStatusModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  Future<UserStatusModel> getUserStatus(num userStatusId) async {
    try {
      final res = await _userStatusApi.getUserStatus(userStatusId);
      return UserStatusModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserStatusModel> getUserStatusByUserId(
      num userStatusId, num seasonYear) async {
    try {
      final res =
          await _userStatusApi.getUserStatusByUserId(userStatusId, seasonYear);
      return UserStatusModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }
}
