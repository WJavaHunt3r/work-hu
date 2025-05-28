import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';

part 'payment_success_state.freezed.dart';

@freezed
abstract class PaymentSuccessState with _$PaymentSuccessState {
  const factory PaymentSuccessState(
      {PaymentsModel? payment,
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _PaymentSuccessState;

  const PaymentSuccessState._();
}
