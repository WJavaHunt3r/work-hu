import 'package:dio/dio.dart';
import 'package:work_hu/features/bufe/data/api/bufe_api.dart';
import 'package:work_hu/features/bufe/data/model/bufe_account_model.dart';
import 'package:work_hu/features/bufe/data/model/bufe_order_items_model.dart';
import 'package:work_hu/features/bufe/data/model/bufe_orders_model.dart';
import 'package:work_hu/features/bufe/data/model/bufe_payments_model.dart';
import 'package:work_hu/features/bufe/data/model/checkout_model.dart';

class BufeRepository {
  final BufeApi _bufeApi;

  BufeRepository(this._bufeApi);

  Future<List<BufePaymentsModel>> getPayments({required num bufeId}) async {
    try {
      final res = await _bufeApi.getPayments(bufeId: bufeId);
      return res.map((e) => BufePaymentsModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  Future<BufeAccountModel> getBufeAccount(num bufeId) async {
    try {
      final res = await _bufeApi.getBufeAccount(bufeId);
      return BufeAccountModel.fromJson(res);
    } catch (e) {
      // return BufeAccountModel(name: "Wagner André", balance: 2000);
      rethrow;
    }
  }

  Future<List<BufeOrdersModel>> getOrders({required num bufeId}) async {
    try {
      final res = await _bufeApi.getOrders(bufeId: bufeId);
      return res.map((e) => BufeOrdersModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  Future<List<BufeOrderItemsModel>> getOrderItems({required num bufeId, required num orderId}) async {
    try {
      final res = await _bufeApi.getOrderItems(bufeId: bufeId, orderId: orderId);
      return res.map((e) => BufeOrderItemsModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  Future<CheckoutModel> createCheckout(
      {required num amount, required String checkoutReference, required String description, required String redirectUrl}) async {
    try {
      final res = await _bufeApi.createCheckout(
          amount: amount, checkoutReference: checkoutReference, description: description, redirectUrl: redirectUrl);
      return CheckoutModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<CheckoutModel> getCheckout({required String checkoutId}) async {
    try {
      final res = await _bufeApi.getCheckout(checkoutId: checkoutId);
      return CheckoutModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<CheckoutModel> deleteCheckout({required String checkoutId}) async {
    try {
      final res = await _bufeApi.deleteCheckout(checkoutId: checkoutId);
      return CheckoutModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<String> createPayment(
      {required num bufeId, required num amount, required String checkoutId, required String date, required String time}) async {
    try {
      return await _bufeApi.createPayment(bufeId, amount, checkoutId, date, time);
    } on DioException {
      rethrow;
    }
  }
}
