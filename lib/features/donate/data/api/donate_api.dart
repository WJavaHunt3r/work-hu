import 'package:work_hu/api/gm_client.dart';
import 'package:work_hu/app/locator.dart';

class DonateApi {
  final GMClient _dioClient = locator<GMClient>();

  DonateApi();

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
}
