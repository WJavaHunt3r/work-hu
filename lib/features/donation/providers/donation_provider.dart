import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/utils.dart';

import '../../bufe/data/repository/bufe_repository.dart';
import '../../bufe/providers/bufe_provider.dart';
import '../data/state/donation_state.dart';

final donationDataProvider = StateNotifierProvider.autoDispose<DonationDataNotifier, DonationState>(
    (ref) => DonationDataNotifier(ref.read(bufeRepoProvider)));

class DonationDataNotifier extends StateNotifier<DonationState> {
  DonationDataNotifier(this.bufeRepository) : super(const DonationState()) {
    amountController = TextEditingController();
  }

  final BufeRepository bufeRepository;
  late final TextEditingController amountController;

  Future<void> createCheckout(String reference, String description) async {
    try {
      state = state.copyWith(modelState: ModelState.processing);
      var response = await bufeRepository.createCheckout(
          amount: num.parse(amountController.text), checkoutReference: reference, description: description);
      var json = {"checkoutId": response.id, "description": description, "locale": "hu-HU", "amount": state.amount};

      String base64String = base64Encode(utf8.encode(jsonEncode(json)));
      state = state.copyWith(modelState: ModelState.success, id: base64String);
    } on DioException catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  void addNumber(String number) {
    var convertedNumber = num.tryParse(amountController.text + number);
    if (convertedNumber != null) {
      amountController.text += number;
      state = state.copyWith(amount: convertedNumber, id: null);
    }
  }

  void removeLastNumber() {
    amountController.text = amountController.text.substring(0, amountController.text.length - 1);
    var convertedNumber = num.tryParse(amountController.text);
    if (convertedNumber != null) {
      state = state.copyWith(amount: convertedNumber, id: null);
    } else {
      state = state.copyWith(amount: 0, id: null);
    }
  }

  Future<void> savePayment() async{
    state = state.copyWith(amount: 0, id: null);
  }
}
