import 'package:work_hu/app/locator.dart';

import '../../../../api/dio_client.dart';

class FraKareWeekApi {
  final DioClient _dioClient = locator<DioClient>();

  FraKareWeekApi();

  Future<List<dynamic>> getFraKareWeeks(num? year, num? weekNumber) async {
    try {
      final res = await _dioClient.dio.get("/fraKareWeek", queryParameters: {"year": year, "weekNumber": weekNumber});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
