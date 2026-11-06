import 'package:dio/dio.dart';
import 'package:work_hu/features/bufe/data/api/bufe_api.dart';
import 'package:work_hu/features/bufe/data/model/kiosk_catalog.dart';
import 'package:work_hu/features/bufe/data/model/sumup_checkout_model.dart';
import 'package:work_hu/features/bufe/data/model/sumup_create_checkout_response.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe/data/model/sumup_user_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

/// [date] as the kiosk takes a birth date ("YYYY-MM-DD", the calendar date as entered, no time zone shift); null when
/// unknown or not in the past, which the kiosk would refuse.
String? kioskBirthDate(DateTime? date, {DateTime? today}) {
  if (date == null) return null;
  final now = today ?? DateTime.now();
  if (!DateTime(date.year, date.month, date.day).isBefore(DateTime(now.year, now.month, now.day))) return null;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${date.year.toString().padLeft(4, '0')}-${two(date.month)}-${two(date.day)}';
}

class BufeRepository {
  final BufeApi _bufeApi;

  BufeRepository(this._bufeApi);

  Future<TopUpResponse> getPayments({required num userId, int? limit = 50, int? offset = 0}) async {
    try {
      final res = await _bufeApi.getPayments(userId: userId, limit: limit, offset: offset);
      return TopUpResponse.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<SumupUserModel> getAccount(num userId) async {
    try {
      final res = await _bufeApi.getAccount(userId);
      return SumupUserModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> getOrders({required num userId, int limit = 50, int page = 0}) async {
    try {
      final res = await _bufeApi.getOrders(userId: userId, limit: limit, offset: page * limit);
      return Order.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<List<DukappImages>> getDukappImages() async {
    try {
      final res = await _bufeApi.getDukappImages();
      return res.map((r) => DukappImages.fromJson(r)).toList();
    } on DioException {
      rethrow;
    }
  }

  Future<dynamic> transferAmount({
    required String userId,
    required String toId,
    required num amount,
    required String externalReferance,
    String? message,
  }) async {
    try {
      final res = await _bufeApi.transferAmount(
        message: message,
        amount: amount,
        fromDukappId: userId,
        toDukappId: toId,
        externalReference: externalReferance,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  Future<SumupCreateCheckoutResponse> createSumupCheckout({
    required num amount,
    required String description,
    required num dukappId,
    required String redirectUrl,
    String? returnUrl,
  }) async {
    try {
      final res = await _bufeApi.createSumupCheckout(
        returnUrl: returnUrl,
        amount: amount,
        dukappId: dukappId,
        description: description,
        redirectUrl: redirectUrl,
      );
      return SumupCreateCheckoutResponse.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<SumupUserModel> createCustomer({
    required String fullname,
    required num dukappId,
    required String email,
    DateTime? birthDate,
  }) async {
    try {
      final res = await _bufeApi.createCustomer(
        fullname: fullname,
        dukappId: dukappId,
        email: email,
        birthDate: kioskBirthDate(birthDate),
      );
      return SumupUserModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<List<KioskLocation>> getLocations() async => [
    for (final l in await _bufeApi.getLocations()) KioskLocation.fromJson(l as Map<String, dynamic>),
  ];

  Future<KioskCatalog> getCatalog(String locationId) async =>
      KioskCatalog.fromJson(await _bufeApi.getCatalog(locationId));

  /// Gives the kiosk [user]'s birth date when its customer [account] has none or another one (customers created before
  /// the kiosk took birth dates, or the user changed it). Returns the updated account, or null when nothing was sent.
  Future<SumupUserModel?> syncBirthDate(UserModel user, SumupUserModel? account) async {
    final birthDate = kioskBirthDate(user.birthDate);
    if (birthDate == null || account?.birth_date == birthDate) return null;
    return createCustomer(
      fullname: user.getFullName(),
      dukappId: user.id,
      email: user.email ?? "",
      birthDate: user.birthDate,
    );
  }

  Future<dynamic> deleteSumupCheckout({required String checkoutId}) async {
    try {
      final res = await _bufeApi.deleteSumupCheckout(checkoutId: checkoutId);
      return res;
    } on DioException {
      rethrow;
    }
  }

  Future<SumupCheckoutModel> getSumupCheckout({required String checkoutId}) async {
    try {
      final res = await _bufeApi.getSumupCheckout(checkoutId: checkoutId);
      return SumupCheckoutModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }
}
