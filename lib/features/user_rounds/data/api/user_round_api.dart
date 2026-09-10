import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class UserRoundApi {
  final DioClient _dioClient = locator<DioClient>();

  UserRoundApi();

  Future<List<dynamic>> listUserRounds([num? userId, num? roundId, num? seasonYear, num? paceTeam]) async {
    try {
      final res = await _dioClient.dio.get("/paceUserRound",
          queryParameters: {"userId": userId, "roundId": roundId, "seasonYear": seasonYear, "paceTeamId": paceTeam});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> recalculate() async {
    try {
      final res = await _dioClient.dio.post("/paceUserRound/recalculate");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getHeadData() async {
    try {
      final res = await _dioClient.dio.get("/paceUserRound/head");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
