import 'package:work_hu/api/bufe_client.dart';
import 'package:work_hu/app/locator.dart';

class BufeApi {
  final BufeClient _dioClient = locator<BufeClient>();

  BufeApi();

  Future<List<dynamic>> getPayments({required num bufeId}) async {
    try {
      final res = await _dioClient.dio.get("/account/$bufeId/payments");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getBufeAccount(num bufeId) async {
    try {
      final res = await _dioClient.dio.get("/account/$bufeId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getOrders({required num bufeId}) async {
    try {
      final res = await _dioClient.dio.get("/account/$bufeId/orders");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getOrderItems({required num bufeId, required num orderId}) async {
    try {
      final res = await _dioClient.dio.get("/account/$bufeId/orders/$orderId/items");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
