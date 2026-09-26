import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/bufe/data/model/sumup_create_checkout_response.dart';
import 'package:work_hu/features/bufe/data/model/sumup_user_model.dart';
import 'package:work_hu/features/bufe/data/repository/bufe_repository.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/top_up/data/state/top_up_state.dart';
import 'package:work_hu/features/transfer_amount/data/state/transfer_amount_state.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';

final transferAmountDataProvider = StateNotifierProvider.autoDispose<TransferAmountDataNotifier, TransferAmountState>(
    (ref) => TransferAmountDataNotifier(ref.watch(bufeRepoProvider)));

class TransferAmountDataNotifier extends BaseDataNotifier<TransferAmountState> {
  TransferAmountDataNotifier(this._bufeRepository) : super(const TransferAmountState()) {
    getAccount();
  }

  final BufeRepository _bufeRepository;
  final UserModel? currentUser = locator<UserProvider>().user;

  Future<void> transfer({required num amount, String? message}) async {
    if (state.selectedUser == null) return;
    await executeApiCall(
        () => _bufeRepository.transferAmount(
            userId: currentUser!.id.toString(),
            toId: state.selectedUser!.id.toString(),
            externalReferance: "transfer_${UniqueKey()}:${currentUser!.id} - ${state.selectedUser!.id}",
            message: message,
            amount: amount), onError: (error) async {
      state = state.copyWith(status: const BaseState(modelState: ModelState.error, message: "transfer_amount_error"));
    });
  }

  @override
  TransferAmountState copyWithState(BaseState status) {
    return state.copyWith(status: status);
  }

  void setSelectedUser(UserComboModel user) {
    state = state.copyWith(selectedUser: user);
  }
  void setAmount(num amount) {
    state = state.copyWith(amount: amount);
  }

  Future<void> getAccount() async {
    var userId = locator<UserProvider>().user!.id;
    executeApiCall<SumupUserModel>(() => _bufeRepository.getAccount(userId), onSuccess: (data) async {
      state = state.copyWith(account: data);
    });
  }
}
