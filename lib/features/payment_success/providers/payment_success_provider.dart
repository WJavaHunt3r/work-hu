import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/features/bufe/data/model/sumup_checkout_model.dart';
import 'package:work_hu/features/bufe/data/repository/bufe_repository.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';
import 'package:work_hu/features/payment_success/data/state/payment_success_state.dart';
import 'package:work_hu/features/payments/data/repository/payments_repository.dart';
import 'package:work_hu/features/payments/providers/payments_provider.dart';

final paymentSuccessDataProvider = StateNotifierProvider.autoDispose<PaymentSuccessDataNotifier, PaymentSuccessState>(
    (ref) => PaymentSuccessDataNotifier(ref.read(paymentRepoProvider), ref.read(bufeRepoProvider)));

class PaymentSuccessDataNotifier extends BaseDataNotifier<PaymentSuccessState> {
  PaymentSuccessDataNotifier(this.paymentRepository, this.bufeRepository) : super(const PaymentSuccessState()) {}

  final PaymentRepository paymentRepository;
  final BufeRepository bufeRepository;

  Future<void> refreshSumupPayment({required String checkoutReference}) async {
    executeApiCall<SumupCheckoutModel>(() => bufeRepository.getSumupCheckout(checkoutId: checkoutReference),
        onSuccess: (data) async {
      state = state.copyWith(payment: data);
      if (data.status != PaymentStatus.PAID) {
        copyWithModelState(ModelState.error);
      }
    });
  }

  @override
  PaymentSuccessState copyWithState(BaseState status) {
    return PaymentSuccessState(status: status);
  }
}
