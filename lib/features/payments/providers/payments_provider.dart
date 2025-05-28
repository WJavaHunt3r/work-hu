import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_goal.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/features/bufe/data/repository/bufe_repository.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/payments/data/api/payments_api.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';
import 'package:work_hu/features/payments/data/repository/payments_repository.dart';
import 'package:work_hu/features/utils.dart';

import '../data/state/payments_state.dart';

final paymentApiProvider = Provider<PaymentsApi>((ref) => PaymentsApi());

final paymentRepoProvider = Provider<PaymentRepository>((ref) => PaymentRepository(ref.read(paymentApiProvider)));

final paymentDataProvider = StateNotifierProvider.autoDispose<PaymentDataNotifier, PaymentsState>(
    (ref) => PaymentDataNotifier(ref.read(paymentRepoProvider), ref.read(bufeRepoProvider)));

class PaymentDataNotifier extends StateNotifier<PaymentsState> {
  PaymentDataNotifier(this.paymentRepository, this.bufeRepository) : super(const PaymentsState()) {}

  final PaymentRepository paymentRepository;
  final BufeRepository bufeRepository;

  Future<void> getPayments() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await paymentRepository
          .getPayments(
              userId: state.userId,
              status: state.status,
              donationId: state.donationId,
              dateFrom: DateTime.now().subtract(Duration(days: 5)))
          .then((payments) {
        payments.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        state = state.copyWith(payments: payments, modelState: ModelState.success);
      });
    } on DioException {
      state = state.copyWith(modelState: ModelState.error, message: "Failed to fetch payments ");
    }
  }

  Future<void> deletePayments(num paymentId, int index, String checkoutId) async {
    List<PaymentsModel> origItems = state.payments;
    List<PaymentsModel> items = [...origItems];
    items.removeWhere((a) => a.id == paymentId);
    state = state.copyWith(payments: items, modelState: ModelState.processing);
    try {
      await bufeRepository.deleteCheckout(checkoutId: checkoutId);
      await paymentRepository
          .deletePayment(paymentId)
          .then((value) => state = state.copyWith(payments: items, modelState: ModelState.success));
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, payments: origItems);
    }
  }

  Future<void> refreshPayment() async {
    var payment = state.selectedPayment!;
    state = state.copyWith(modelState: ModelState.processing);
    try {
      if (payment.status == PaymentStatus.PENDING) {
        var checkout = await bufeRepository.getCheckout(checkoutId: payment.checkoutId);
        if (checkout.status == PaymentStatus.PAID) {
          var newPayment = await paymentRepository.putPayment(payment.copyWith(status: PaymentStatus.PAID), payment.id!);
          if (newPayment.paymentGoal == PaymentGoal.BUFE) {
            await bufeRepository.createPayment(
                bufeId: payment.recipient?.bufeId ?? payment.user!.bufeId!,
                amount: payment.amount,
                checkoutId: payment.checkoutId,
                date: Utils.dateToStringWithDots(DateTime.now()),
                time: Utils.dateToTimeString(DateTime.now()));
          }
          state = state.copyWith(selectedPayment: newPayment, modelState: ModelState.success);
        } else if (checkout.status == PaymentStatus.EXPIRED) {
          var newPayment = await paymentRepository.putPayment(payment.copyWith(status: PaymentStatus.EXPIRED), payment.id!);
          state = state.copyWith(selectedPayment: newPayment, modelState: ModelState.success);
        }
      }
      state = state.copyWith(modelState: ModelState.success);
    } on DioException catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  presetFilter({num? userId, num? donationId, PaymentStatus? status}) {
    state = state.copyWith(userId: userId, donationId: donationId, status: status);
    getPayments();
  }

  Future<void> setPaymentId(num? paymentId) async {
    if (paymentId != null) {
      state = state.copyWith(modelState: ModelState.processing);
      try {
        await paymentRepository.getPayment(paymentId).then((payments) {
          state = state.copyWith(selectedPayment: payments, modelState: ModelState.success);
        });
      } on DioException {
        state = state.copyWith(modelState: ModelState.error, message: "Failed to fetch payment ");
      }
    } else {
      state = state.copyWith(selectedPayment: null);
    }
  }
}
