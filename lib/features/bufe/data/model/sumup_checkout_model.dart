import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/payment_status.dart';

part 'sumup_checkout_model.freezed.dart';

part 'sumup_checkout_model.g.dart';

@freezed
class SumupCheckoutModel with _$SumupCheckoutModel {
  const factory SumupCheckoutModel(
      {required PaymentStatus status,
        required int amount,
      @JsonKey(name: 'dukapp_id') required String dukappId,
      @JsonKey(name: 'new_balance')  num? newBalance,
      }) = _SumupCheckoutModel;

  factory SumupCheckoutModel.fromJson(Map<String, dynamic> json) => _$SumupCheckoutModelFromJson(json);
}
