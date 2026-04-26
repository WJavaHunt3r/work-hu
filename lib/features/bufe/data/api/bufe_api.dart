import 'package:work_hu/api/bufe_client.dart';
import 'package:work_hu/app/locator.dart';

class BufeApi {
  final BufeClient _dioClient = locator<BufeClient>();

  BufeApi();

  Future<dynamic> getPayments({required num userId, int? limit = 50, int? offset = 0}) async {
    try {
      final res = await _dioClient.dio
          .get("external-customer-topups", queryParameters: {"dukapp_id": userId, "limit": limit, "offset": offset});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getAccount(num userId) async {
    try {
      final res = await _dioClient.dio.get("external-customer", queryParameters: {"dukapp_id": userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getOrders({required num userId, int? limit = 50, int? offset = 0}) async {
    try {
      final res = await _dioClient.dio
          .get("external-customer-orders", queryParameters: {"dukapp_id": userId, "limit": limit, "offset": offset});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createSumupCheckout(
      {required num amount,
      required String description,
      required num dukappId,
      required String redirectUrl,
      String? returnUrl}) async {
    try {
      final res = await _dioClient.dio.post("/sumup-create-checkout", data: {
        "amount": amount,
        "description": description,
        "currency": "HUF",
        "redirect_url": redirectUrl,
        "return_url": returnUrl,
        "dukapp_id": dukappId
      });
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createCheckout(
      {required num amount,
      required String checkoutReference,
      required String description,
      required String redirectUrl,
      String? returnUrl}) async {
    try {
      final res = await _dioClient.dio.post("/checkouts", data: {
        "checkout_reference": checkoutReference,
        "amount": amount,
        "description": description,
        "currency": "HUF",
        "redirect_url": redirectUrl,
        "return_url": returnUrl
      });
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCheckout({required String checkoutId}) async {
    try {
      final res = await _dioClient.dio.get("/checkouts/$checkoutId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteCheckout({required String checkoutId}) async {
    try {
      final res = await _dioClient.dio.delete("/checkouts/$checkoutId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteSumupCheckout({required String checkoutId}) async {
    try {
      final res = await _dioClient.dio.delete("sumup-checkout-delete", queryParameters: {"id": checkoutId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getSumupCheckout({required String checkoutId}) async {
    try {
      final res = await _dioClient.dio.get("sumup-checkout-status", queryParameters: {"checkout_reference": checkoutId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
