import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class TeamApi {
  final DioClient _dioClient = locator<DioClient>();

  TeamApi();

  Future<List<dynamic>> fetchTeamsApiRequest() async {
    try {
      final res = await _dioClient.dio.get("/teams");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}