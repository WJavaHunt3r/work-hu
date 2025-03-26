import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';

part 'card_fill_state.freezed.dart';

@freezed
abstract class CardFillState with _$CardFillState {
  const factory CardFillState(
      {
        String? base64,
        String? checkoutId,
        PaymentsModel? payment,
        num? bufeId,
        @Default(0) num amount,
        @Default(ModelState.empty) ModelState paymentState,
        @Default(ModelState.empty) ModelState modelState,
        @Default("") String message}) = _CardFillState;

  const CardFillState._();
}