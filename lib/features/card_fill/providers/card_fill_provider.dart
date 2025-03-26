import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
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
import 'package:work_hu/features/utils.dart';

import '../../bufe/data/repository/bufe_repository.dart';
import '../../bufe/providers/bufe_provider.dart';
import '../data/state/card_fill_state.dart';

final cardFillDataProvider = StateNotifierProvider.autoDispose<CardFillDataNotifier, CardFillState>(
    (ref) => CardFillDataNotifier(ref.read(bufeRepoProvider), ref.read(paymentRepoProvider), ref.read(userDataProvider)));

class CardFillDataNotifier extends StateNotifier<CardFillState> {
  CardFillDataNotifier(this.bufeRepository, this.paymentRepository, this.currentUser) : super(const CardFillState()) {
    amountController = TextEditingController();
  }

  final BufeRepository bufeRepository;
  final PaymentRepository paymentRepository;
  final UserModel? currentUser;
  late final TextEditingController amountController;

  void setBufeId(num bufeId) {
    state = state.copyWith(bufeId: bufeId);
  }

  Future<void> createCheckout() async {
    try {
      var desc = "payment_${state.bufeId!}_${UniqueKey()}";
      state = state.copyWith(modelState: ModelState.processing);
      var response = await bufeRepository.createCheckout(
          amount: num.parse(amountController.text), checkoutReference: desc, description: desc);

      var payment = PaymentsModel(
          paymentGoal: PaymentGoal.BUFE,
          dateTime: DateTime.now(),
          description: "Büfé kártya feltöltés",
          amount: response.amount,
          checkoutReference: response.checkout_reference,
          checkoutId: response.id,
          status: response.status,
          user: currentUser!);

      var paymentResponse = await paymentRepository.postPayment(payment);

      var json = {"checkoutId": response.id, "description": "Büfé kártya feltöltés", "locale": "hu-HU", "amount": state.amount};

      String base64String = base64Encode(utf8.encode(jsonEncode(json)));
      state =
          state.copyWith(modelState: ModelState.success, base64: base64String, payment: paymentResponse, checkoutId: response.id);
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
      await bufeRepository.createPayment(
          bufeId: state.bufeId!,
          amount: state.amount,
          checkoutId: state.checkoutId!,
          date: Utils.dateToStringWithDots(DateTime.now()),
          time: Utils.dateToTimeString(DateTime.now()));

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
      state = state.copyWith(modelState: ModelState.success, base64: null, checkoutId: null,amount: 0);
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
