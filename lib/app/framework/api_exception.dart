import 'package:dio/dio.dart';
import 'package:work_hu/app/providers/router_provider.dart';
import 'package:work_hu/features/utils.dart';

/// An error the backend explained with a plain-text body (e.g. 409 "Job is full", 422 "Registration is closed").
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  /// The backend's message, or null if the response carries none.
  static ApiException? fromDio(DioException e) {
    final data = e.response?.data;
    final status = e.response?.statusCode;
    if (data is String && data.trim().isNotEmpty) return ApiException(data.trim(), statusCode: status);
    if (data is Map && data["message"] is String) return ApiException(data["message"], statusCode: status);
    return null;
  }

  @override
  String toString() => message;
}

/// Runs [call] and turns a failed request into an [ApiException] when the backend said why, so
/// `BaseDataNotifier.executeApiCall` (with `onError`) can show the real reason.
Future<T> guardApi<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (e) {
    throw ApiException.fromDio(e) ?? e;
  }
}

/// Shows [message] in the standard error dialog on top of whatever is open.
void showApiError(String message) {
  final context = navigatorKey.currentContext;
  if (context != null) Utils.showErrorDialog(context, content: message);
}
