import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/payments/data/api/payments_api.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';
import 'package:work_hu/features/payments/data/repository/payments_repository.dart';

import '../data/state/payments_state.dart';

final paymentApiProvider = Provider<PaymentsApi>((ref) => PaymentsApi());

final paymentRepoProvider = Provider<PaymentRepository>((ref) => PaymentRepository(ref.read(paymentApiProvider)));

final paymentDataProvider = StateNotifierProvider.autoDispose<PaymentDataNotifier, PaymentsState>(
    (ref) => PaymentDataNotifier(ref.read(paymentRepoProvider)));

class PaymentDataNotifier extends StateNotifier<PaymentsState> {
  PaymentDataNotifier(this.paymentRepository) : super(const PaymentsState()) {}

  final PaymentRepository paymentRepository;

  Future<void> getPayments() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await paymentRepository
          .getPayments(userId: state.userId, status: state.status, donationId: state.donationId)
          .then((payments) {
        payments.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        state = state.copyWith(payments: payments, modelState: ModelState.success);
      });
    } on DioException {
      state = state.copyWith(modelState: ModelState.error, message: "Failed to fetch payments ");
    }
  }

  Future<void> deletePayments(num paymentId, int index) async {
    List<PaymentsModel> origItems = state.payments;
    List<PaymentsModel> items = [...origItems];
    items.removeWhere((a) => a.id != paymentId);
    state = state.copyWith(payments: items, modelState: ModelState.processing);
    try {
      await paymentRepository
          .deletePayment(paymentId)
          .then((value) => state = state.copyWith(payments: items, modelState: ModelState.success));
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, payments: origItems);
    }
  }

  Future<void> updatePayment(PaymentsModel payment) async {
    // userController.text = "${payment.user?.getFullName()} (${payment.user?.getAge()}) ";
    state = state.copyWith(selectedPayment: payment);
  }

// Future<void> savePayment() async {
//   var mode = state.mode;
//   state = state.copyWith(modelState: ModelState.processing);
//   var payment = state.selectedPayment;
//   try {
//     if (payment != null) {
//       if (mode == MaintenanceMode.create) {
//         await paymentRepository.postPayment(payment, currentUser!.id);
//       } else if (mode == MaintenanceMode.edit) {
//         await paymentRepository.putPayment(payment, payment.id!);
//       }
//       state = state.copyWith(selectedPayment: null, modelState: ModelState.success);
//     } else {
//       state = state.copyWith(modelState: ModelState.error, message: "Error");
//     }
//   } catch (e) {
//     state = state.copyWith(modelState: ModelState.error, message: e.toString());
//   }
// }

  presetFilter({num? userId, num? donationId, PaymentStatus? status}) {
    state = state.copyWith(userId: userId, donationId: donationId, status: status);
    getPayments();
  }
}
