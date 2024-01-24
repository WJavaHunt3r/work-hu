import 'package:dio/dio.dart';
import 'package:work_hu/features/user_camps/data/api/user_camp_api.dart';
import 'package:work_hu/features/user_camps/data/model/user_camp_model.dart';

class UserCampRepository {
  final UserCampApi _userCampApi;

  UserCampRepository(this._userCampApi);

  Future<List<UserCampModel>> getUserCamps(num seasonId) async {
    try {
      final res = await _userCampApi.getUserCamps(seasonId);
      return res.map((e) => UserCampModel.fromJson(e)).toList();
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<UserCampModel> getUserCamp(num userCampId) async {
    try {
      final res = await _userCampApi.getUserCamp(userCampId);
      return UserCampModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCampModel> postUserCamp(UserCampModel userCamp) async {
    try {
      final res = await _userCampApi.postUserCamp(userCamp);
      return UserCampModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCampModel> putUserCamp(UserCampModel userCamp, num userCampId) async {
    try {
      final res = await _userCampApi.putUserCamp(userCamp, userCampId);
      return UserCampModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }
}
