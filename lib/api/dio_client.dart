import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class DioClient {
  // static const String _baseUrl = "http://192.168.0.241:80/work-hu/api"; //Home
  // static const String _baseUrl = "http://192.168.0.143:8990/work-hu/api"; //Márkó
  // static const String _baseUrl = "http://192.168.94.91:8990/work-hu/api"; //hotspot
  // static const String _baseUrl = "http://10.67.28.59:8990/work-hu/api"; //hotspot
  static const String _baseUrl = "http://localhost:8990/dukapp/api"; //meló
  // static const String _baseUrl = "https://dukappservice.bcc-ktk.org/work-hu/api"; //Duka
  // static const String _baseUrl = "https://petraandre.bcc-ktk.or g/work-hu/api"; //localhost
  // static const String _baseUrl = "http://78.139.43.2:8990/work-hu/api"; //távoli
  // static const String _baseUrl = "https://liger-OPTIMAL-antelope.ngrok-free.app/work-hu/api"; //ngrok

  static const String _dioContentType = 'application/json';

  static const Duration _dioConnectTimeout = Duration(seconds: 30);

  static const Duration _dioSendTimeout = Duration(seconds: 30);

  static const Duration _dioReceiveTimeout = Duration(seconds: 60);

  final Dio _dio = Dio(
    BaseOptions(headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": true,
      "Access-Control-Allow-Headers": "*",
      "Access-Control-Allow-Methods": "GET, POST, OPTIONS"
    }),
  );

  DioClient() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = _dioConnectTimeout;
    // _dio.options.sendTimeout = _dioSendTimeout;
    _dio.options.receiveTimeout = _dioReceiveTimeout;
    _dio.options.contentType = _dioContentType;
    // var adapter = BrowserHttpClientAdapter();
    // adapter.withCredentials = true;
    // _dio.httpClientAdapter = adapter;
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Dio get dio => _dio;
}
