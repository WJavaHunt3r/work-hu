import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class DioClient {
  // static const String _baseUrl = "http://192.168.1.167:8990/work-hu/api"; //Home
  // static const String _baseUrl = "http://10.0.20.176:8990/work-hu/api"; //meló
  // static const String _baseUrl = "http://10.10.10.236:8990/work-hu/api"; //Duka
  // static const String _baseUrl = "http://78.139.43.2:8990/work-hu/api"; //távoli
  static const String _baseUrl = "https://liger-OPTIMAL-antelope.ngrok-free.app/work-hu/api"; //ngrok

  final Dio _dio = Dio(BaseOptions(headers: {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Credentials": false,
    "Access-Control-Allow-Headers": "*",
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
    "ngrok-skip-browser-warning": "69420"
  }));

  DioClient() {
    _dio.options.baseUrl = _baseUrl;
    // var adapter = BrowserHttpClientAdapter();
    // adapter.withCredentials = true;
    // _dio.httpClientAdapter = adapter;
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Dio get dio => _dio;
}
