import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/utils.dart';

import '../app/providers/user_provider.dart';

@singleton
class DioClient {
  // Override for a device on the LAN: --dart-define=API_BASE_URL=http://<mac-ip>:8990/dukapp/api
  //static const String _baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: "http://192.168.0.102:8990/dukapp/api"); //meló
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
        final token = locator<UserProvider>().token ?? await Utils.getData("jwt_token");
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        final statusCode = e.response?.statusCode;
        if (statusCode == 401|| statusCode == 403) {
          final refreshToken = await Utils.getData('refresh_token');

          if (refreshToken.isEmpty) {
            await locator<UserProvider>().logout();
            return handler.next(e);
          }

          final String newAccessToken;
          try {
            final response = await _plainDio.post('/auth/refreshtoken', data: {
              'refreshToken': refreshToken,
            });

            newAccessToken = response.data['accessToken'];
            final String? newRefreshToken = response.data['refreshToken'];

            await Utils.saveData('jwt_token', newAccessToken);
            // Keep the current refresh token if the backend does not rotate it.
            if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
              await Utils.saveData('refresh_token', newRefreshToken);
            }
            locator<UserProvider>().setToken(newAccessToken);
          } on DioException catch (refreshError) {
            // Only a rejected refresh token ends the session; network errors and
            // server errors keep the tokens so the next attempt can succeed.
            final refreshStatus = refreshError.response?.statusCode;
            if (refreshStatus == 400 || refreshStatus == 401 || refreshStatus == 403) {
              await locator<UserProvider>().logout();
            }
            return handler.next(e);
          } catch (_) {
            return handler.next(e);
          }

          // Retry the original request with the new access token. Uses the interceptor-free
          // Dio so a failing retry cannot re-enter this queued handler and deadlock.
          try {
            final opts = e.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newAccessToken';
            return handler.resolve(await _plainDio.fetch(opts));
          } on DioException catch (retryError) {
            return handler.next(retryError);
          }
        }
        return handler.next(e);
      },
    ));
  }

  /// Same base URL, no auth/refresh interceptors. For token refresh, retries and logout.
  final Dio _plainDio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: _dioConnectTimeout,
    receiveTimeout: _dioReceiveTimeout,
    contentType: _dioContentType,
  ));

  Dio get dio => _dio;

  Dio get plainDio => _plainDio;
}
