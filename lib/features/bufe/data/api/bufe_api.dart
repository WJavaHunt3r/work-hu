import 'package:work_hu/api/bufe_client.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/bufe/data/model/checkout_model.dart';

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

  Future<dynamic> createCheckout({required num amount, required String checkoutReference, required String description}) async {
    try {
      final res = await _dioClient.dio.get("/create_checkout",
          queryParameters: {"checkout_reference": checkoutReference, "amount": amount, "description": description});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
