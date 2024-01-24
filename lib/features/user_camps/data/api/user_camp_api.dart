import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/user_camps/data/model/user_camp_model.dart';

import '../../../../api/dio_client.dart';

class UserCampApi {
  final DioClient _dioClient = locator<DioClient>();

  UserCampApi();

  Future<List<dynamic>> getUserCamps(num? seasonId) async {
    try {
      final res = await _dioClient.dio.get("/userCamps", queryParameters: {"seasonId": seasonId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getUserCamp(num userCampId) async {
    try {
      final res = await _dioClient.dio.get("/userCamp", queryParameters: {"userCampId": userCampId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postUserCamp(UserCampModel userCamp) async {
    try {
      final res = await _dioClient.dio.post("/userCamp", data: userCamp);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> putUserCamp(UserCampModel userCamp, num userCampId) async {
    try {
      final res = await _dioClient.dio.put("/userCamp", queryParameters: {"userCampId": userCampId}, data: userCamp);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
