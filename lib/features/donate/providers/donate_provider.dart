import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/payment_goal.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/donation/data/repository/donation_repository.dart';
import 'package:work_hu/features/donation/providers/donation_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/payments/data/model/payments_model.dart';
import 'package:work_hu/features/payments/data/repository/payments_repository.dart';
import 'package:work_hu/features/payments/providers/payments_provider.dart';

import '../../bufe/data/repository/bufe_repository.dart';
import '../../bufe/providers/bufe_provider.dart';
import '../data/state/donate_state.dart';

final donateDataProvider = StateNotifierProvider.autoDispose<DonateDataNotifier, DonateState>((ref) => DonateDataNotifier(
    ref.read(bufeRepoProvider), ref.read(donationRepoProvider), ref.read(paymentRepoProvider), ref.read(userDataProvider)));

class DonateDataNotifier extends StateNotifier<DonateState> {
  DonateDataNotifier(this.bufeRepository, this.donationRepository, this.paymentRepository, this.currentUser)
      : super(const DonateState()) {
    amountController = TextEditingController();
  }

  final BufeRepository bufeRepository;
  final DonationRepository donationRepository;
  final PaymentRepository paymentRepository;
  final UserModel? currentUser;
  late final TextEditingController amountController;

  Future<void> getDonation(num id) async {
    try {
      state = state.copyWith(modelState: ModelState.processing);
      await donationRepository.getDonation(id).then((d) => state = state.copyWith(donation: d, modelState: ModelState.success));
    } on DioException catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> createCheckout() async {
    try {
      state = state.copyWith(modelState: ModelState.processing);
      var reference = "donation_${state.donation!.id!}_${UniqueKey().toString().replaceAll("#", "")}";
      var response = await bufeRepository.createCheckout(
          amount: num.parse(amountController.text),
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

      var json = {
        "checkoutId": response.id,
        "description": state.donation!.description,
        "locale": "hu-HU",
        "amount": state.amount
      };

      String base64String = base64Encode(utf8.encode(jsonEncode(json)));
      state = state.copyWith(
          modelState: ModelState.success,
          hosted_url: response.hosted_checkout_url,
          base64: base64String,
          payment: paymentResponse,
          checkoutId: response.id);
    } on Exception catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  void addNumber(String number) {
    var convertedNumber = num.tryParse(amountController.text + number);
    if (convertedNumber != null) {
      amountController.text += number;
      state = state.copyWith(amount: convertedNumber, base64: null, checkoutId: null);
    }
  }

  void removeLastNumber() {
    amountController.text = amountController.text.substring(0, amountController.text.length - 1);
    var convertedNumber = num.tryParse(amountController.text);
    if (convertedNumber != null) {
      state = state.copyWith(amount: convertedNumber, base64: null, checkoutId: null);
    } else {
      state = state.copyWith(amount: 0, base64: null, checkoutId: null);
    }
  }

  Future<void> savePayment() async {
    amountController.text = '';
    try {
      state = state.copyWith(modelState: ModelState.processing);

      var payment = state.payment!;
      await paymentRepository.putPayment(payment.copyWith(status: PaymentStatus.PAID), payment.id!);
      amountController.text = '';
      state = state.copyWith(amount: 0, modelState: ModelState.success, base64: null, checkoutId: null);
    } on DioException catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<void> deleteCheckout(PaymentStatus status) async {
    try {
      state = state.copyWith(modelState: ModelState.processing);
      await deleteCheckoutApi(status, state.checkoutId!, state.payment!);
      amountController.text = '';
      state = state.copyWith(modelState: ModelState.success, base64: null, checkoutId: null, amount: 0);
    } on DioException catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<dynamic> deleteCheckoutApi(PaymentStatus status, String checkoutId, PaymentsModel payment) async {
    await bufeRepository.deleteCheckout(checkoutId: checkoutId);
    await paymentRepository.putPayment(payment.copyWith(status: status), payment.id!);
  }

  @override
  void dispose() {
    if (state.checkoutId != null) {
      deleteCheckoutApi(PaymentStatus.EXPIRED, state.checkoutId!, state.payment!);
    }
    super.dispose();
  }
}
