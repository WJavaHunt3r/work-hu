import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class BufeClient {
  static const String _baseUrl = "https://fngkzlmhfegroyulcgfc.supabase.co/functions/v1/"; //Duka

  final Dio _dio = Dio(BaseOptions(headers: {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Credentials": true,
    "Access-Control-Allow-Headers": "*",
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
    "x-api-key": "nPRQouRH28vI2Z2X8zwu9lwnqugJQ2ER"
  }));

  BufeClient() {
    _dio.options.baseUrl = _baseUrl;
    // var adapter = BrowserHttpClientAdapter();
    // adapter.withCredentials = true;
    // _dio.httpClientAdapter = adapter;
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Dio get dio => _dio;
}
