import 'package:work_hu/app/locator.dart';

import '../../../../api/dio_client.dart';

class UserFraKareWeekApi {
  final DioClient _dioClient = locator<DioClient>();

  UserFraKareWeekApi();

  Future<List<dynamic>> getUserFraKareWeeks(num? userId, num? weekNumber, bool? listened, num? teamId, num? year) async {
    try {
      final res = await _dioClient.dio.get("/userFraKareWeek", queryParameters: {
        "userId": userId,
        "weekNumber": weekNumber,
        "listened": listened,
        "teamId": teamId,
        "seasonYear": year
      });
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> putUserFraKareWeek(bool listened, num id) async {
    try {
      final res = await _dioClient.dio.put("/userFraKareWeek/$id/setListened", queryParameters: {"listened": listened});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteFraKareWeek(num id) async {
    try {
      final res = await _dioClient.dio.put("/userFraKareWeek/$id");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
