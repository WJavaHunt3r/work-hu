import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/utils.dart';

import '../app/providers/user_provider.dart';

@singleton
class DioClient {
  static const String _baseUrl = "http://localhost:8990/dukapp/api"; //meló
  // static const String _baseUrl = "https://dukappservice.bcc-ktk.org/dukapp/api"; //Duka

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
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 1. Fetch token from Secure Storage (or your runtime provider)
        final token = locator<UserProvider>().token ?? await Utils.getData("jwt_token");

        // 2. If token exists, attach to header
        if (token != '') {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // 3. Handle 401 Unauthorized (Token expired)
        if (e.response?.statusCode == 401) {
          // Log the user out or refresh token
        }
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}
