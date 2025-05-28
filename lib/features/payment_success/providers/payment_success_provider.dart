import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_goal.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/features/bufe/data/repository/bufe_repository.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';
import 'package:work_hu/features/payment_success/data/state/payment_success_state.dart';
import 'package:work_hu/features/payments/data/repository/payments_repository.dart';
import 'package:work_hu/features/payments/providers/payments_provider.dart';
import 'package:work_hu/features/utils.dart';

final paymentSuccessDataProvider = StateNotifierProvider<PaymentSuccessDataNotifier, PaymentSuccessState>(
    (ref) => PaymentSuccessDataNotifier(ref.read(paymentRepoProvider), ref.read(bufeRepoProvider)));

class PaymentSuccessDataNotifier extends StateNotifier<PaymentSuccessState> {
  PaymentSuccessDataNotifier(this.paymentRepository, this.bufeRepository) : super(const PaymentSuccessState()) {}

  final PaymentRepository paymentRepository;
  final BufeRepository bufeRepository;

  Future<void> refreshPayment({String? checkoutReference, num? bufeId}) async {
    state = state.copyWith(modelState: ModelState.processing);
    if (checkoutReference != null && bufeId != null) {
      try {
        var payments = await paymentRepository.getPayments(checkoutReference: checkoutReference);
        if (payments.length != 1) {
          state = state.copyWith(modelState: ModelState.error, message: "Hiba a fizetés lekérdezése során");
        } else {
          var payment = payments[0];
          var checkout = await bufeRepository.getCheckout(checkoutId: payment.checkoutId);
          if (checkout.status == PaymentStatus.PAID && payment.status != PaymentStatus.PAID) {
            var newPayment = await paymentRepository.putPayment(payment.copyWith(status: PaymentStatus.PAID), payment.id!);
            if (newPayment.paymentGoal == PaymentGoal.BUFE) {
              await bufeRepository.createPayment(
                  bufeId: bufeId ?? payment.user!.bufeId!,
                  amount: payment.amount,
                  checkoutId: payment.checkoutId,
                  date: Utils.dateToStringWithDots(DateTime.now()),
                  time: Utils.dateToTimeString(DateTime.now()));
            }
            state = state.copyWith(payment: newPayment, modelState: ModelState.success);
          } else if (checkout.status == PaymentStatus.PENDING) {
            var newPayment = await paymentRepository.putPayment(payment.copyWith(status: PaymentStatus.EXPIRED), payment.id!);
            await bufeRepository.deleteCheckout(checkoutId: payment.checkoutId);
            state = state.copyWith(payment: newPayment, modelState: ModelState.success);
          } else if (checkout.status == PaymentStatus.FAILED) {
            var newPayment = await paymentRepository.putPayment(payment.copyWith(status: PaymentStatus.FAILED), payment.id!);
            state = state.copyWith(payment: newPayment, modelState: ModelState.success);
          } else {
            state = state.copyWith(modelState: ModelState.success, payment: payment);
          }
        }
      } on DioException catch (e) {
        state = state.copyWith(modelState: ModelState.error, message: e.toString());
      }
    } else {
      state = state.copyWith(modelState: ModelState.error, message: "Nincs checkoutId");
    }
  }
}
