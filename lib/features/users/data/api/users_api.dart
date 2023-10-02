import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/home/data/model/team_model.dart';

class UsersApi {
  final DioClient _dioClient = locator<DioClient>();

  UsersApi();

  Future<List<dynamic>> getUsers([TeamModel? teamModel, bool? listO36]) async {
    try {
      Map<String, dynamic> map = {"listO36": listO36};
      if (teamModel != null) map.addAll({"teamId": teamModel.id});
      final res = await _dioClient.dio.get("/users", queryParameters: map);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
