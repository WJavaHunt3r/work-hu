import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class UserRoundApi {
  final DioClient _dioClient = locator<DioClient>();

  UserRoundApi();

  Future<List<dynamic>> fetchUserRoundsApiRequest([num? userId, num? roundId, num? seasonYear]) async {
    try {
      final res = await _dioClient.dio
          .get("/paceUserRound", queryParameters: {"userId": userId, "roundId": roundId, "seasonYear": seasonYear});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
