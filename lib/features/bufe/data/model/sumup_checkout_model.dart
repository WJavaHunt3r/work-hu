import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/payment_status.dart';

part 'sumup_checkout_model.freezed.dart';

part 'sumup_checkout_model.g.dart';

@freezed
abstract class SumupCheckoutModel with _$SumupCheckoutModel {
  const factory SumupCheckoutModel({
    required PaymentStatus status,
    required int amount,
    @JsonKey(name: 'dukapp_id') required String dukappId,
    @JsonKey(name: 'new_balance') num? newBalance,
    @JsonKey(name: 'checkout_reference') required String checkoutReference,
    required String description,
    @JsonKey(name: 'hosted_url')required String hostedUrl,
    @JsonKey(name: 'entry_mode') String? entryMode,
    @JsonKey(name: 'transaction_date') required DateTime transactionDate,
  }) = _SumupCheckoutModel;

  factory SumupCheckoutModel.fromJson(Map<String, dynamic> json) => _$SumupCheckoutModelFromJson(json);
}
