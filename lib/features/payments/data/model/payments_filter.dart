import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/payment_status.dart';

part 'payments_filter.freezed.dart';

@freezed
abstract class PaymentsFilter with _$PaymentsFilter {
  const factory PaymentsFilter({num? userId, num? donationId, PaymentStatus? status}) = _PaymentsFilter;
}
