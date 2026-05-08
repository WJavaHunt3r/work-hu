import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';

part 'donate_state.freezed.dart';

@freezed
abstract class DonateState with _$DonateState {
  const factory DonateState(
      {
        String? base64,
        String? checkoutId,
        DonationModel? donation,
        PaymentsModel? payment,
        String? hosted_url,
        @Default(0) num amount,
        @Default(ModelState.empty) ModelState paymentState,
        @Default(BaseState()) BaseState status}) = _DonateState;

  const DonateState._();
}