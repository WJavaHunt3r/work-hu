import 'package:dio/dio.dart';
import 'package:work_hu/features/camps/data/api/camps_api.dart';
import 'package:work_hu/features/camps/data/model/camp_model.dart';

class CampRepository {
  final CampsApi _campApi;

  CampRepository(this._campApi);

  Future<List<CampModel>> getCamps(num seasonId) async {
    try {
      final res = await _campApi.getCamps(seasonId);
      return res.map((e) => CampModel.fromJson(e)).toList();
    } on DioError {
      rethrow;
    }
  }

  Future<CampModel> getCamp(num campId) async {
    try {
      final res = await _campApi.getCamp(campId);
      return CampModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<CampModel> postCamp(CampModel camp) async {
    try {
      final res = await _campApi.postCamp(camp);
      return CampModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<CampModel> putCamp(CampModel camp, num campId) async {
    try {
      final res = await _campApi.putCamp(camp, campId);
      return CampModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }
}
