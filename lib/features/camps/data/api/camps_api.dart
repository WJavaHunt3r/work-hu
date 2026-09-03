import 'package:work_hu/app/framework/base_components/page_stru.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/camps/data/model/camp_filter.dart';
import 'package:work_hu/features/camps/data/model/camp_model.dart';

import '../../../../api/dio_client.dart';

class CampApi {
  final DioClient _dioClient = locator<DioClient>();

  CampApi();

  Future<dynamic> getCamps({required CampFilter filter, required PageStru pageStru}) async {
    try {
      final res = await _dioClient.dio.get("/camp", queryParameters: filter.toJson());
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCamp(num campId) async {
    try {
      final res = await _dioClient.dio.get("/camp$campId");
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
      final res = await _dioClient.dio.put("/camp/$campId", data: camp);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteCamp(num campId) async {
    try {
      final res = await _dioClient.dio.put("/camp/$campId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
