import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/utils.dart';

import '../app/providers/user_provider.dart';

@singleton
class DioClient {
  // static const String _baseUrl = "http://localhost:8990/dukapp/api"; //meló
  static const String _baseUrl = "https://dukappservice.bcc-ktk.org/dukapp/api"; //Duka

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
    _dio.options.receiveTimeout = _dioReceiveTimeout;
    _dio.options.contentType = _dioContentType;

    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    // Use QueuedInterceptor to prevent race conditions during token refresh
    _dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = locator<UserProvider>().token ?? await const FlutterSecureStorage().read(key: "jwt_token");
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          final storage = const FlutterSecureStorage();
          final refreshToken = await storage.read(key: 'refresh_token');

          if (refreshToken != null) {
            try {
              // Separate Dio instance to avoid looping interceptors
              final refreshDio = Dio(BaseOptions(baseUrl: _baseUrl));
              final response = await refreshDio.post('/auth/refreshtoken', data: {
                'refreshToken': refreshToken,
              });

              final newAccessToken = response.data['accessToken'];
              final newRefreshToken = response.data['refreshToken'];

              // Store new tokens
              await storage.write(key: 'jwt_token', value: newAccessToken);
              await storage.write(key: 'refresh_token', value: newRefreshToken);
              locator<UserProvider>().setToken(newAccessToken);

              // Retry original request with the new access token
              final opts = e.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newAccessToken';
              final cloneReq = await _dio.request(
                opts.path,
                options: Options(method: opts.method, headers: opts.headers),
                data: opts.data,
                queryParameters: opts.queryParameters,
              );

              return handler.resolve(cloneReq);
            } catch (refreshError) {
              // Refresh token expired or revoked -> force logout
              await locator<UserProvider>().logout();
              return handler.reject(e);
            }
          } else {
            await locator<UserProvider>().logout();
          }
        }
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}
