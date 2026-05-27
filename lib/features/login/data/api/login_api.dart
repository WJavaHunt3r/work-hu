import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/login/data/model/register_model.dart';

class LoginApi {
  final DioClient _dioClient = locator<DioClient>();

  LoginApi();

  Future<dynamic> loginRequest(String username, String password) async {
    try {
      final res = await _dioClient.dio.post("/auth/login", data: {'username': username, "password": password});
      // var jwt = res.headers.value("set-cookie")?.split(';')[0];
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

  Future<dynamic> getProfile() async {
    try {
      final res = await _dioClient.dio.get("/user/me");
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

  Future<dynamic> loginWithGoogleRequest(String idToken) async {
    try {
      final res = await _dioClient.dio.post("/auth/google", data: {'idToken': idToken});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> isAlive() async {
    try {
      final res = await _dioClient.dio.get("/auth/isAlive");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> registerRequest(RegisterModel userData) async {
    try {
      final res = await _dioClient.dio.post("/auth/register", data: userData.toJson());
      // var jwt = res.headers.value("set-cookie")?.split(';')[0];
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getBookingToken() async {
    try {
      final res = await _dioClient.dio.get("/auth/bookingToken");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
