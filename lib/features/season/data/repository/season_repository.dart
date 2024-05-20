
import 'package:dio/dio.dart';
import 'package:work_hu/features/season/data/api/season_api.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';

class SeasonRepository {
  final SeasonApi _seasonApi;

  SeasonRepository(this._seasonApi);

  Future<List<SeasonModel>> getSeasons() async {
    try {
      final res = await _seasonApi.getSeasons();
      return res.map((e) => SeasonModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }
}
