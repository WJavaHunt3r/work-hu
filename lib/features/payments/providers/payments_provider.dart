import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/features/donate/providers/donate_provider.dart';
import 'package:work_hu/features/donate/repository/donate_repository.dart';
import 'package:work_hu/features/payments/data/api/payments_api.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';
import 'package:work_hu/features/payments/data/repository/payments_repository.dart';

import '../data/state/payments_state.dart';

final paymentApiProvider = Provider<PaymentsApi>((ref) => PaymentsApi());

final paymentRepoProvider = Provider<PaymentRepository>((ref) => PaymentRepository(ref.read(paymentApiProvider)));

final paymentDataProvider = StateNotifierProvider.autoDispose<PaymentDataNotifier, PaymentsState>(
    (ref) => PaymentDataNotifier(ref.read(paymentRepoProvider), ref.read(donateRepoProvider)));

class PaymentDataNotifier extends BaseDataNotifier<PaymentsState> implements ListApiProvider {
  PaymentDataNotifier(this.paymentRepository, this.donateRepository) : super(const PaymentsState()) {
    list();
  }

  final PaymentRepository paymentRepository;
  final DonateRepository donateRepository;

  @override
  Future<void> list({filter, int? page, int? size, String? sort}) async {
    executeApiCall<List<PaymentsModel>>(
        () => paymentRepository.getPayments(
            userId: state.userId,
            status: state.paymentStatus,
            donationId: state.donationId,
            dateFrom: DateTime.now().subtract(Duration(days: 7))), onSuccess: (payments) async {
      payments.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      state = state.copyWith(payments: payments);
    });
  }

  Future<void> deletePayments(num paymentId, int index, String checkoutId) async {
    List<PaymentsModel> origItems = state.payments;
    List<PaymentsModel> items = [...origItems];
    items.removeWhere((a) => a.id == paymentId);
    executeApiCall(() async {
      donateRepository.deleteCheckout(checkoutId: checkoutId);
    }, onSuccess: (data) async {
      await paymentRepository.deletePayment(paymentId);
    }, onError: (d) async {
      state = state.copyWith(payments: items);
      state = copyWithModelState(ModelState.error);
    });
  }

  Future<void> refreshPayments() async {
    for (var payment in state.payments.where((e) => e.status == PaymentStatus.PENDING)) {
      executeApiCall(() => refreshPayment(payment));
    }

    list();
  }

  Future<void> refreshPayment(PaymentsModel payment) async {
    if (payment.status == PaymentStatus.PENDING) {
      var checkout = await donateRepository.getCheckout(checkoutId: payment.checkoutId);
      if (checkout.status == PaymentStatus.PAID) {
        var newPayment = await paymentRepository.putPayment(payment.copyWith(status: PaymentStatus.PAID), payment.id!);
        state = state.copyWith(selectedPayment: newPayment);
      } else if (checkout.status == PaymentStatus.EXPIRED) {
        var newPayment = await paymentRepository.putPayment(payment.copyWith(status: PaymentStatus.EXPIRED), payment.id!);
        state = state.copyWith(selectedPayment: newPayment);
      }
    }
  }

  presetFilter({num? userId, num? donationId, PaymentStatus? status}) {
    state = state.copyWith(userId: userId, donationId: donationId);
    list();
  }

  Future<void> getPayment(num? paymentId) async {
    if (paymentId != null) {
      executeApiCall<PaymentsModel>(() async {
        paymentRepository.getPayment(paymentId);
      }, onSuccess: (data) async {
        state = state.copyWith(selectedPayment: data);
      });
    } else {
      state = state.copyWith(selectedPayment: null);
    }
  }

  @override
  PaymentsState copyWithState(BaseState status) {
    return PaymentsState(status: state.status.copyWith(baseStatus: status));
  }
}
