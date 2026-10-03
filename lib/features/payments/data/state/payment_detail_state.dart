import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';

part 'payment_detail_state.freezed.dart';

@freezed
abstract class PaymentDetailState with _$PaymentDetailState {
  const factory PaymentDetailState({PaymentsModel? selectedPayment, @Default(BaseState()) BaseState status}) =
      _PaymentDetailState;
}
