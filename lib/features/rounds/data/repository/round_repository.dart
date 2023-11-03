import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:work_hu/features/rounds/data/api/round_api.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';

class RoundRepository {
  final RoundApi _roundApi;

  RoundRepository(this._roundApi);

  Future<List<RoundModel>> getRounds() async {
    try {
      final res = await _roundApi.getRounds();
      return res.map((e) => RoundModel.fromJson(e)).toList();
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<RoundModel> getCurrentRounds() async {
    try {
      final res = await _roundApi.getCurrentRound();
      return RoundModel.fromJson(res);
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<RoundModel> getRound([num? roundId]) async {
    try {
      final res = await _roundApi.getRound(roundId);
      return RoundModel.fromJson(res);
    } on DioError catch (e) {
      rethrow;
    }
  }
}
