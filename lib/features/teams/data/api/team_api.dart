import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class TeamApi {
  final DioClient _dioClient = locator<DioClient>();

  TeamApi();

  Future<List<dynamic>> fetchTeamRoundsApiRequest() async {
    try {
      final res = await _dioClient.dio.get("/paceTeamRounds");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getTeams() async {
    try {
      final res = await _dioClient.dio.get("/paceTeams");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}