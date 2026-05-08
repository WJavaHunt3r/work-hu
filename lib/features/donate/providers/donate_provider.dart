import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_goal.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/donate/repository/donate_repository.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/donation/data/repository/donation_repository.dart';
import 'package:work_hu/features/donation/providers/donation_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';
import 'package:work_hu/features/payments/data/repository/payments_repository.dart';
import 'package:work_hu/features/payments/providers/payments_provider.dart';

import '../data/api/donate_api.dart';
import '../data/state/donate_state.dart';

final donateApiProvider = Provider<DonateApi>((ref) => DonateApi());

final donateRepoProvider = Provider<DonateRepository>((ref) => DonateRepository(ref.read(donateApiProvider)));

final donateDataProvider = StateNotifierProvider.autoDispose<DonateDataNotifier, DonateState>((ref) => DonateDataNotifier(
    ref.read(donateRepoProvider),
    ref.read(donationRepoProvider),
    ref.read(paymentRepoProvider),
    ref.read(userDataProvider).user));

class DonateDataNotifier extends BaseDataNotifier<DonateState> {
  DonateDataNotifier(this.donateRepository, this.donationRepository, this.paymentRepository, this.currentUser)
      : super(const DonateState());

  final DonateRepository donateRepository;
  final DonationRepository donationRepository;
  final PaymentRepository paymentRepository;
  final UserModel? currentUser;

  Future<void> getDonation(num id) async {
    executeApiCall<DonationModel>(() => donationRepository.getDonation(id), onSuccess: (data) async {
      state = state.copyWith(donation: data);
    });
  }

  Future<void> createCheckout(int amount) async {
    var reference = "donation_${state.donation!.id!}_${UniqueKey().toString().replaceAll("#", "")}";
    var response = await donateRepository.createCheckout(
        amount: amount,
        checkoutReference: reference,
        description: state.donation!.description!,
        redirectUrl: "donate/${state.donation!.id}/success/$reference");

    var payment = PaymentsModel(
        paymentGoal: PaymentGoal.DONATION,
        dateTime: DateTime.now(),
        description: response.description,
        amount: response.amount,
        checkoutReference: response.checkout_reference,
        checkoutId: response.id,
        status: response.status,
        donation: state.donation);

    var paymentResponse = await paymentRepository.postPayment(payment);

    var json = {"checkoutId": response.id, "description": state.donation!.description, "locale": "hu-HU", "amount": state.amount};

    String base64String = base64Encode(utf8.encode(jsonEncode(json)));
    state = state.copyWith(
        hosted_url: response.hosted_checkout_url,
        base64: base64String,
        payment: paymentResponse,
        checkoutId: response.id,
        status: const BaseState(modelState: ModelState.success));
  }

  Future<void> savePayment() async {
    var payment = state.payment!;
    await paymentRepository.putPayment(payment.copyWith(status: PaymentStatus.PAID), payment.id!);
  }

  Future<void> deleteCheckout(PaymentStatus status) async {
    await executeApiCall(() => deleteCheckoutApi(status, state.checkoutId!, state.payment!));
  }

  Future<dynamic> deleteCheckoutApi(PaymentStatus status, String checkoutId, PaymentsModel payment) async {
    await donateRepository.deleteCheckout(checkoutId: checkoutId);
    await paymentRepository.putPayment(payment.copyWith(status: status), payment.id!);
  }

  @override
  void dispose() {
    if (state.checkoutId != null) {
      deleteCheckoutApi(PaymentStatus.EXPIRED, state.checkoutId!, state.payment!);
    }
    super.dispose();
  }

  @override
  DonateState copyWithState(BaseState status) {
    return state.copyWith(status: status);
  }
}
