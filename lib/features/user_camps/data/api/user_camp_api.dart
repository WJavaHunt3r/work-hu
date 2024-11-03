import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/user_camps/data/model/user_camp_model.dart';

import '../../../../api/dio_client.dart';

class UserCampApi {
  final DioClient _dioClient = locator<DioClient>();

  UserCampApi();

  Future<List<dynamic>> getUserCamps(num? seasonYear, num? userId, num? campId, bool? participates) async {
    try {
      final res = await _dioClient.dio.get("/userCamp", queryParameters: {
        "seasonYear": seasonYear,
        "userId": userId,
        "campId": campId,
        "participates": participates
      });
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getUserCamp(num userCampId) async {
    try {
      final res = await _dioClient.dio.get("/userCamp/$userCampId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getUserCampByUserId(num userId) async {
    try {
      final res = await _dioClient.dio.get("/userCamp/user/$userId");
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
      final res = await _dioClient.dio.put("/userCamp/$userCampId", data: userCamp);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
