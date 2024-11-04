import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/bufe/data/api/bufe_api.dart';
import 'package:work_hu/features/bufe/data/repository/bufe_repository.dart';
import 'package:work_hu/features/bufe/data/state/bufe_state.dart';

final bufeApiProvider = Provider<BufeApi>((ref) => BufeApi());

final bufeRepoProvider = Provider<BufeRepository>((ref) => BufeRepository(ref.read(bufeApiProvider)));

final bufeDataProvider = StateNotifierProvider.autoDispose<BufeDataNotifier, BufeState>(
    (ref) => BufeDataNotifier(ref.read(bufeRepoProvider), ref.read(userDataProvider.notifier)));

class BufeDataNotifier extends StateNotifier<BufeState> {
  BufeDataNotifier(this.bufeRepository, this.currentUserProvider) : super(const BufeState()) {
    getAccount();
  }

  final BufeRepository bufeRepository;
  final UserDataNotifier currentUserProvider;

  FutureOr<void> getAccount() async {
    state = state.copyWith(modelState: ModelState.processing);
    var user = currentUserProvider.state!;
    try {
      if (user.bufeId != null) {
        await bufeRepository.getBufeAccount(user.bufeId!).then((data) async {
          state = state.copyWith(account: data, modelState: ModelState.success);
        });
        getPayments(user.bufeId!);
      }
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  FutureOr<void> getPayments(num userId) async {
    state = state.copyWith(modelState: ModelState.processing);
    var user = currentUserProvider.state!;
    try {
      await bufeRepository.getPayments(bufeId: userId).then((data) async {
        data.sort((a, b) => b.date.compareTo(a.date));
        state = state.copyWith(payments: data, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }
}
