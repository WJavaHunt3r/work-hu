import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class DioClient {
  // static const String _baseUrl = "http://192.168.1.169:8990/work-hu/api"; //Home
  // static const String _baseUrl = "http://192.168.191.57:8990/work-hu/api"; //Márkó
  // static const String _baseUrl = "http://192.168.94.91:8990/work-hu/api"; //hotspot
  // static const String _baseUrl = "http://10.67.28.59:8990/work-hu/api"; //hotspot
  // static const String _baseUrl = "http://localhost:8990/work-hu/api"; //meló
  static const String _baseUrl = "https://dukappservice.bcc-ktk.org/work-hu/api"; //Duka
  // static const String _baseUrl = "https://aksjon.bcc-ktk.org/work-hu/api"; //localhost
  // static const String _baseUrl = "http://78.139.43.2:8990/work-hu/api"; //távoli
  // static const String _baseUrl = "https://liger-OPTIMAL-antelope.ngrok-free.app/work-hu/api"; //ngrok

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
