import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class GMClient {
  static const String _baseUrl = "https://gm.bcc-ktk.org"; //Duka

  final Dio _dio = Dio(BaseOptions(headers: {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Credentials": true,
    "Access-Control-Allow-Headers": "*",
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  }));

  GMClient() {
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Dio get dio => _dio;
}
