import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/bufe/data/api/bufe_api.dart';
import 'package:work_hu/features/bufe/data/model/bufe_account_model.dart';
import 'package:work_hu/features/bufe/data/model/bufe_orders_model.dart';
import 'package:work_hu/features/bufe/data/repository/bufe_repository.dart';
import 'package:work_hu/features/bufe/data/state/bufe_state.dart';

final bufeApiProvider = Provider<BufeApi>((ref) => BufeApi());

final bufeRepoProvider = Provider<BufeRepository>((ref) => BufeRepository(ref.read(bufeApiProvider)));

final bufeDataProvider =
    StateNotifierProvider<BufeDataNotifier, BufeState>((ref) => BufeDataNotifier(ref.read(bufeRepoProvider)));

class BufeDataNotifier extends StateNotifier<BufeState> {
  BufeDataNotifier(this.bufeRepository) : super(const BufeState()) {
    // getAccounts();
  }

  final BufeRepository bufeRepository;

  FutureOr<void> getAccounts(num bufeId) async {
    state = const BufeState(modelState: ModelState.processing);
    try {
      var userAccount = await getAccount(bufeId);

      state = state.copyWith(account: userAccount, modelState: ModelState.success);

      await getPayments(bufeId);
      await getOrders(bufeId);
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<BufeAccountModel?> getAccount(num bufeId) async {
    try {
      return await bufeRepository.getBufeAccount(bufeId);
    } catch (e) {
      return null;
    }
  }

  FutureOr<void> getPayments(num userId) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await bufeRepository.getPayments(bufeId: userId).then((data) async {
        data.sort((a, b) => b.date.compareTo(a.date));
        state = state.copyWith(payments: data, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  FutureOr<void> getOrders(num bufeId) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await bufeRepository.getOrders(bufeId: bufeId).then((data) async {
        data.sort((a, b) => b.date.compareTo(a.date));
        state = state.copyWith(orders: data, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  FutureOr<void> getOrderItems(num bufeId, num orderId) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await bufeRepository.getOrderItems(bufeId: bufeId, orderId: orderId).then((data) {
        state = state.copyWith(orderItems: data, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  void setSelectedOrder(BufeOrdersModel order) {
    if (state.account == null) return;
    getOrderItems(state.account!.id, order.orderId);
    state = state.copyWith(selectedOrder: order);
  }
}
