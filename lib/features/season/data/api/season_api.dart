
import 'package:work_hu/app/locator.dart';

import '../../../../api/dio_client.dart';

class SeasonApi {
  final DioClient _dioClient = locator<DioClient>();

  SeasonApi();

  Future<List<dynamic>> getSeasons() async {
    try {
      final res = await _dioClient.dio.get("/seasons");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}