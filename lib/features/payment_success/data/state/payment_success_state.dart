import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/bufe/data/model/sumup_checkout_model.dart';

part 'payment_success_state.freezed.dart';

@freezed
abstract class PaymentSuccessState with _$PaymentSuccessState {
  const factory PaymentSuccessState({SumupCheckoutModel? payment, @Default(BaseState()) BaseState status}) =
      _PaymentSuccessState;

  const PaymentSuccessState._();
}
