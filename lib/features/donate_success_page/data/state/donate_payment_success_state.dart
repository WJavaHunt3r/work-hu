import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/features/bufe/data/model/sumup_checkout_model.dart';
import 'package:work_hu/features/donate/model/checkout_model.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';

part 'donate_payment_success_state.freezed.dart';

@freezed
abstract class DonatePaymentSuccessState with _$DonatePaymentSuccessState {
  const factory DonatePaymentSuccessState({CheckoutModel? payment, @Default(BaseState()) BaseState status}) = _DonatePaymentSuccessState;

  const DonatePaymentSuccessState._();
}
