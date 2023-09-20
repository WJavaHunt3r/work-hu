import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class DioClient {

  static const String _baseUrl = "http://192.168.1.167:8990/work-hu/api";

  final Dio _dio = Dio(
      BaseOptions(connectTimeout: 3000)
  );

  DioClient() {
    _dio.options.baseUrl =_baseUrl;
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Dio get dio => _dio;

}