import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/payment_goal.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

part 'payments_model.freezed.dart';

part 'payments_model.g.dart';

@freezed
class PaymentsModel with _$PaymentsModel {
  const factory PaymentsModel({
    num? id,
    required DateTime dateTime,
    required String description,
    required num amount,
    required String checkoutReference,
    required String checkoutId,
    required PaymentStatus status,
    required PaymentGoal paymentGoal,
    UserModel? user,
    DonationModel? donation

  }) = _PaymentsModel;

  factory PaymentsModel.fromJson(Map<String, dynamic> json) => _$PaymentsModelFromJson(json);
}
