import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/features/donate/providers/donate_provider.dart';
import 'package:work_hu/features/donate/repository/donate_repository.dart';
import 'package:work_hu/features/payments/data/api/payments_api.dart';
import 'package:work_hu/features/payments/data/model/payments_filter.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';
import 'package:work_hu/features/payments/data/repository/payments_repository.dart';
import 'package:work_hu/features/payments/data/state/payment_detail_state.dart';

final paymentApiProvider = Provider<PaymentsApi>((ref) => PaymentsApi());

final paymentRepoProvider = Provider<PaymentRepository>((ref) => PaymentRepository(ref.read(paymentApiProvider)));

/// The payments of the last week, by filter.
final paymentDataProvider = StateNotifierProvider.autoDispose
    .family<PaymentDataNotifier, PagedState<PaymentsModel, PaymentsFilter>, PaymentsFilter>(
      (ref, filter) => PaymentDataNotifier(ref.read(paymentRepoProvider), ref.read(donateRepoProvider), filter),
    );

final paymentDetailProvider = StateNotifierProvider.autoDispose<PaymentDetailNotifier, PaymentDetailState>(
  (ref) => PaymentDetailNotifier(ref.read(paymentRepoProvider), ref.read(donateRepoProvider)),
);

/// Copies the status of a pending payment's checkout to the payment. Returns the payment as it is now.
Future<PaymentsModel> _syncPendingPayment(
  PaymentsModel payment,
  PaymentRepository paymentRepository,
  DonateRepository donateRepository,
) async {
  if (payment.status != PaymentStatus.PENDING) return payment;
  final checkout = await donateRepository.getCheckout(checkoutId: payment.checkoutId);
  if (checkout.status == PaymentStatus.PAID || checkout.status == PaymentStatus.EXPIRED) {
    return paymentRepository.putPayment(payment.copyWith(status: checkout.status), payment.id!);
  }
  return payment;
}

class PaymentDataNotifier extends PagedListNotifier<PaymentsModel, PaymentsFilter> {
  PaymentDataNotifier(this.paymentRepository, this.donateRepository, PaymentsFilter filter)
    : super(ListQuery(filter: filter));

  final PaymentRepository paymentRepository;
  final DonateRepository donateRepository;

  /// Not paged by the server: returns the last week at once, newest first.
  @override
  Future<PaginatedResponse<PaymentsModel>> fetch(ListQuery<PaymentsFilter> query, int page) async {
    final payments = await paymentRepository.getPayments(
      userId: query.filter.userId,
      status: query.filter.status,
      donationId: query.filter.donationId,
      dateFrom: DateTime.now().subtract(const Duration(days: 7)),
    );
    payments.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return PaginatedResponse.all(payments);
  }

  /// Cancels the payment's checkout, then deletes the payment.
  Future<void> deletePayment(PaymentsModel payment) async {
    await executeApiCall(() async {
      await donateRepository.deleteCheckout(checkoutId: payment.checkoutId);
      return paymentRepository.deletePayment(payment.id!);
    }, onSuccess: (_) async => removeItems((p) => p.id == payment.id));
  }

  /// Updates every pending payment from its checkout, then reloads.
  Future<void> refreshPayments() async {
    final pending = state.items.where((p) => p.status == PaymentStatus.PENDING).toList();
    await executeApiCall(() async {
      for (final payment in pending) {
        await _syncPendingPayment(payment, paymentRepository, donateRepository);
      }
      return true;
    }, onSuccess: (_) => reload());
  }
}

/// The payment shown in the payment dialog.
class PaymentDetailNotifier extends BaseDataNotifier<PaymentDetailState> {
  PaymentDetailNotifier(this.paymentRepository, this.donateRepository) : super(const PaymentDetailState());

  final PaymentRepository paymentRepository;
  final DonateRepository donateRepository;

  Future<void> getPayment(num? paymentId) async {
    if (paymentId == null) {
      state = state.copyWith(selectedPayment: null);
      return;
    }
    await executeApiCall<PaymentsModel>(
      () => paymentRepository.getPayment(paymentId),
      onSuccess: (data) async {
        state = state.copyWith(selectedPayment: data);
      },
    );
  }

  Future<void> refreshPayment(PaymentsModel payment) async {
    await executeApiCall<PaymentsModel>(
      () => _syncPendingPayment(payment, paymentRepository, donateRepository),
      onSuccess: (data) async {
        state = state.copyWith(selectedPayment: data);
      },
    );
  }

  @override
  PaymentDetailState copyWithState(BaseState status) => state.copyWith(status: status);
}
