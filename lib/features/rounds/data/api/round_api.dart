import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class RoundApi {
  final DioClient _dioClient = locator<DioClient>();

  RoundApi();

  Future<List<dynamic>> getRounds(num? seasonYear) async {
    try {
      final res = await _dioClient.dio.get("/rounds", queryParameters: {"seasonYear": seasonYear});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCurrentRound() async {
    try {
      final res = await _dioClient.dio.get("/currentRound");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getRound(num? roundId) async {
    try {
      final res = await _dioClient.dio.get("/round", queryParameters: {"roundId": roundId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
