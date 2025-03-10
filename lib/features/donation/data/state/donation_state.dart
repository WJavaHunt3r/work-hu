import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';

part 'donation_state.freezed.dart';

@freezed
abstract class DonationState with _$DonationState {
  const factory DonationState(
      {
        String? id,
        @Default(0) num amount,
        @Default(ModelState.empty) ModelState paymentState,
        @Default(ModelState.empty) ModelState modelState,
        @Default("") String message}) = _DonationState;

  const DonationState._();
}