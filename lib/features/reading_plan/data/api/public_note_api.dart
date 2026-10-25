import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

/// Public notes on the reading plan's items (`/reading-plan/{planId}/public-notes`).
class PublicNoteApi {
  DioClient get _dioClient => locator<DioClient>();

  String _base(num planId) => "/reading-plan/$planId/public-notes";

  Future<List<dynamic>> getForItem(num planId, int item) async =>
      (await _dioClient.dio.get(_base(planId), queryParameters: {"item": item})).data as List<dynamic>;

  Future<Map<String, dynamic>> getCounts(num planId) async =>
      (await _dioClient.dio.get("${_base(planId)}/counts")).data as Map<String, dynamic>;

  Future<Map<String, dynamic>> create(num planId, Map<String, dynamic> note) async =>
      (await _dioClient.dio.post(_base(planId), data: note)).data as Map<String, dynamic>;

  Future<Map<String, dynamic>> update(num planId, num id, String text) async =>
      (await _dioClient.dio.put("${_base(planId)}/$id", data: {"text": text})).data as Map<String, dynamic>;

  Future<void> delete(num planId, num id) => _dioClient.dio.delete("${_base(planId)}/$id");

  Future<void> report(num planId, num id, String? reason) =>
      _dioClient.dio.post("${_base(planId)}/$id/report", data: {"reason": reason});

  // Managers (READING_PLAN_MANAGE)

  Future<List<dynamic>> getReported(num planId) async =>
      (await _dioClient.dio.get("${_base(planId)}/reported")).data as List<dynamic>;

  Future<void> setHidden(num planId, num id, bool hidden) =>
      _dioClient.dio.put("${_base(planId)}/$id/hidden", data: {"hidden": hidden});
}
