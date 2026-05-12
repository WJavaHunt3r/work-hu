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

  Future<dynamic> transferAmount(
      {required num amount,
      required String fromDukappId,
      required String toDukappId,
      required String externalReference,
      String? message}) async {
    try {
      final res = await _dioClient.dio.post("/external-transfer", data: {
        "amount": amount,
        "to_dukapp_id": toDukappId,
        "from_dukapp_id": fromDukappId,
        "metadata": {"message": message},
        "external_reference": externalReference
      });
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

  Future<dynamic> createCustomer({
    required String fullname,
    required num dukappId,
    required String email,
  }) async {
    try {
      final res = await _dioClient.dio.post("/external-create-customer", data: {
        "full_name": fullname,
        "dukapp_id": dukappId.toString(),
        "email": email,
      });
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
