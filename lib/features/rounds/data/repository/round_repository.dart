import 'package:dio/dio.dart';
import 'package:work_hu/features/rounds/data/api/round_api.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';

class RoundRepository {
  final RoundApi _roundApi;

  RoundRepository(this._roundApi);

  Future<List<RoundModel>> getRounds([num? seasonYear, bool? activeRound]) async {
    try {
      final res = await _roundApi.getRounds(seasonYear, activeRound);
      return res.map((e) => RoundModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  Future<RoundModel> getCurrentRounds() async {
    try {
      final res = await _roundApi.getCurrentRound();
      return RoundModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<RoundModel> getRound([num? roundId]) async {
    try {
      final res = await _roundApi.getRound(roundId);
      return RoundModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<RoundModel> postRound({required RoundModel round}) async {
    try {
      final res = await _roundApi.postRound(round);
      return RoundModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<RoundModel> putRound(RoundModel round, num roundId) async {
    try {
      final res = await _roundApi.putRound(round, roundId);
      return RoundModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }
}
