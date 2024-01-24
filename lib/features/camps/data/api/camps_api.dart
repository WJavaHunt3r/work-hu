import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/camps/data/model/camp_model.dart';

import '../../../../api/dio_client.dart';

class CampsApi {
  final DioClient _dioClient = locator<DioClient>();

  CampsApi();

  Future<List<dynamic>> getCamps(num? seasonId) async {
    try {
      final res = await _dioClient.dio.get("/camps", queryParameters: {"seasonId": seasonId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCamp(num campId) async {
    try {
      final res = await _dioClient.dio.get("/camp", queryParameters: {"campId": campId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postCamp(CampModel camp) async {
    try {
      final res = await _dioClient.dio.post("/camp", data: camp);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> putCamp(CampModel camp, num campId) async {
    try {
      final res = await _dioClient.dio.put("/camp", queryParameters: {"campId": campId}, data: camp);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
