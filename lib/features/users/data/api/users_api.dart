import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';

class UsersApi {
  final DioClient _dioClient = locator<DioClient>();

  UsersApi();

  Future<List<dynamic>> getUsers([TeamModel? teamModel, bool? listO36]) async {
    try {
      Map<String, dynamic> map = {"listO36": listO36};
      if (teamModel != null) map.addAll({"teamId": teamModel.id});
      final res = await _dioClient.dio.get("/user", queryParameters: map);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getUserById(num userId) async {
    try {
      final res = await _dioClient.dio.get("/user/$userId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getUserByMyShareId(num myShareId) async {
    try {
      final res = await _dioClient.dio.get("/user/myShare/$myShareId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> resetPassword(num userID, num changerId) async {
    try {
      final res = await _dioClient.dio.post("/auth/resetPassword", data: {'userId': userID, "changerId": changerId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateUser(num userId, UserModel user) async {
    try {
      final res =
          await _dioClient.dio.put("/user/${user.id}", queryParameters: {'modifyUserId': userId}, data: user.toJson());
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
