import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/bufe/data/api/bufe_api.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe/data/model/sumup_user_model.dart';
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

  Future<void> getAccounts(num userId) async {
    state = const BufeState(modelState: ModelState.loading);
    try {
      var userAccount = await getAccount(userId);

      state = state.copyWith(account: userAccount, modelState: ModelState.success);

      await getPayments(userId);
      await getOrders(userId);
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<SumupUserModel?> getAccount(num userId) async {
    try {
      return await bufeRepository.getAccount(userId);
    } catch (e) {
      return null;
    }
  }

  FutureOr<void> getPayments(num userId) async {
    state = state.copyWith(modelState: ModelState.loading);
    try {
      await bufeRepository.getPayments(userId: userId).then((data) async {
        data.items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        state = state.copyWith(payments: data.items, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  FutureOr<void> getOrders(num userId) async {
    state = state.copyWith(modelState: ModelState.loading);
    try {
      await bufeRepository.getOrders(userId: userId).then((data) async {
        data.items.sort((a, b) => b.date.compareTo(a.date));
        state = state.copyWith(orders: data.items, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  // FutureOr<void> getOrderItems(num userId, num orderId) async {
  //   state = state.copyWith(modelState: ModelState.processing);
  //   try {
  //     await bufeRepository.getOrderItems(userId: userId, orderId: orderId).then((data) {
  //       state = state.copyWith(orderItems: data, modelState: ModelState.success);
  //     });
  //   } catch (e) {
  //     state = state.copyWith(modelState: ModelState.error);
  //   }
  // }

  void setSelectedOrder(OrderEntry order) {
    if (state.account == null) return;
    state = state.copyWith(selectedOrder: order);
  }
}
