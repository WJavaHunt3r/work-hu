import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class TeamRoundApi {
  final DioClient _dioClient = locator<DioClient>();

  TeamRoundApi();

  Future<List<dynamic>> fetchTeamRoundsApiRequest() async {
    try {
      final res = await _dioClient.dio.get("/paceTeamRounds", queryParameters: {"seasonYear": DateTime.now().year});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> recalculateTeamRounds() async {
    try {
      final res = await _dioClient.dio.post("/paceTeamRounds/recalculate");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
