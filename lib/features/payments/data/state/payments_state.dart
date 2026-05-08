import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';

part 'payments_state.freezed.dart';

@freezed
abstract class PaymentsState with _$PaymentsState {
  const factory PaymentsState(
      {@Default([]) List<PaymentsModel> payments,
      num? donationId,
      num? userId,
      PaymentStatus? paymentStatus,
      PaymentsModel? selectedPayment,
      @Default(MaintenanceMode.create) MaintenanceMode mode,
      @Default(BaseListState()) BaseListState status}) = _PaymentsState;

  const PaymentsState._();
}
