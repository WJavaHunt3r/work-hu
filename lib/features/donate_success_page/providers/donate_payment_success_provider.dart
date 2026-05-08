import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/features/donate/model/checkout_model.dart';
import 'package:work_hu/features/donate/providers/donate_provider.dart';
import 'package:work_hu/features/donate/repository/donate_repository.dart';
import 'package:work_hu/features/donate_success_page/data/state/donate_payment_success_state.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';
import 'package:work_hu/features/payments/data/repository/payments_repository.dart';
import 'package:work_hu/features/payments/providers/payments_provider.dart';

final donatePaymentSuccessDataProvider =
    StateNotifierProvider.autoDispose<DonatePaymentSuccessDataNotifier, DonatePaymentSuccessState>(
        (ref) => DonatePaymentSuccessDataNotifier(ref.read(paymentRepoProvider), ref.read(donateRepoProvider)));

class DonatePaymentSuccessDataNotifier extends BaseDataNotifier<DonatePaymentSuccessState> {
  DonatePaymentSuccessDataNotifier(this.paymentRepository, this.donateRepository) : super(const DonatePaymentSuccessState()) {}

  final PaymentRepository paymentRepository;
  final DonateRepository donateRepository;

  Future<void> refreshPayment({required String checkoutReference}) async {
    executeApiCall<List<PaymentsModel>>(() => paymentRepository.getPayments(checkoutReference: checkoutReference),
        onSuccess: (data) async {
      if (data.length != 1) {
        state = state.copyWith(status: const BaseState(modelState: ModelState.error, message: "donate_error"));
      } else {
        var payment = data[0];
        executeApiCall<CheckoutModel>(() => donateRepository.getCheckout(checkoutId: payment.checkoutId),
            onSuccess: (checkout) async {
          state = state.copyWith(payment: checkout);
          if (checkout.status == PaymentStatus.PAID && payment.status != PaymentStatus.PAID) {
            await paymentRepository.putPayment(payment.copyWith(status: PaymentStatus.PAID), payment.id!);
          } else if (checkout.status == PaymentStatus.PENDING) {
            var newPayment = await paymentRepository.putPayment(payment.copyWith(status: PaymentStatus.EXPIRED), payment.id!);
            await donateRepository.deleteCheckout(checkoutId: payment.checkoutId);
            copyWithModelState(ModelState.success);
          } else if (checkout.status == PaymentStatus.FAILED) {
            await paymentRepository.putPayment(payment.copyWith(status: PaymentStatus.FAILED), payment.id!);
            copyWithModelState(ModelState.error);
          } else {
            copyWithModelState(ModelState.success);
          }
        });
      }
    });
  }

  @override
  DonatePaymentSuccessState copyWithState(BaseState status) {
    return DonatePaymentSuccessState(status: status);
  }
}
