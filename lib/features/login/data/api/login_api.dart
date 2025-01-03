import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class LoginApi {
  final DioClient _dioClient = locator<DioClient>();

  LoginApi();

  Future<dynamic> loginRequest(String username, String password) async {
    try {
      final res = await _dioClient.dio.post("/auth/login", data: {'username': username, "password": password});
      var jwt = res.headers.value("set-cookie")?.split(';')[0];
      if (jwt != null && jwt.isNotEmpty) _dioClient.dio.options.headers.addAll({"Cookie": jwt});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getUserByUsername(String username) async {
    try {
      final res = await _dioClient.dio.get("/user/username/$username");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getUser(num id) async {
    try {
      final res = await _dioClient.dio.get("/user/$id");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> sendNewPassword(String username) async {
    try {
      final res = await _dioClient.dio.post("/auth/sendNewPassword", data: {'username': username});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
