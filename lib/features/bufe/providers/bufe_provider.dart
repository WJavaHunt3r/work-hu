import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/bufe/data/api/bufe_api.dart';
import 'package:work_hu/features/bufe/data/model/bufe_account_model.dart';
import 'package:work_hu/features/bufe/data/repository/bufe_repository.dart';
import 'package:work_hu/features/bufe/data/state/bufe_state.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

final bufeApiProvider = Provider<BufeApi>((ref) => BufeApi());

final bufeRepoProvider = Provider<BufeRepository>((ref) => BufeRepository(ref.read(bufeApiProvider)));

final bufeDataProvider = StateNotifierProvider.autoDispose<BufeDataNotifier, BufeState>((ref) =>
    BufeDataNotifier(ref.read(bufeRepoProvider), ref.read(userDataProvider.notifier), ref.watch(usersRepoProvider)));

class BufeDataNotifier extends StateNotifier<BufeState> {
  BufeDataNotifier(this.bufeRepository, this.currentUserProvider, this.usersRepo) : super(const BufeState()) {
    getAccounts();
  }

  final BufeRepository bufeRepository;
  final UserDataNotifier currentUserProvider;
  final UsersRepository usersRepo;

  FutureOr<void> getAccounts() async {
    state = state.copyWith(modelState: ModelState.processing);
    var user = currentUserProvider.state!;
    try {
      if (user.bufeId != null) {
        var accounts = <BufeAccountModel>[];
        var userAccount = await getAccount(user.bufeId!);
        if (userAccount != null) accounts.add(userAccount);

        if (user.spouseId != null) {
          var spouse = await usersRepo.getUserById(user.spouseId!);
          if (spouse.bufeId != null) {
            var spouseAccount = await getAccount(spouse.bufeId!);
            if (spouseAccount != null) accounts.add(spouseAccount);
          }
        }

        await usersRepo.getChildren(user.id).then((kids) async {
          for (var kid in kids) {
            if (kid.bufeId != null) {
              var kidAccount = await getAccount(kid.id);
              if (kidAccount != null) accounts.add(kidAccount);
            }
          }
        });

        state = state.copyWith(accounts: accounts, modelState: ModelState.success);

        getPayments(user.bufeId!);
      }
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
