import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe/data/model/sumup_user_model.dart';
import 'package:work_hu/features/bufe/data/repository/bufe_repository.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';
import 'package:work_hu/features/donation/data/repository/donation_repository.dart';
import 'package:work_hu/features/donation/providers/donation_provider.dart';
import 'package:work_hu/features/home/data/state/home_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

final homeDataProvider = StateNotifierProvider.autoDispose<HomeDataNotifier, HomeState>(
    (ref) => HomeDataNotifier(ref.watch(bufeRepoProvider), ref.read(donationRepoProvider), ref.read(usersRepoProvider)));

class HomeDataNotifier extends BaseDataNotifier<HomeState> {
  HomeDataNotifier(this._bufeRepository, this._donationRepository, this._usersRepository) : super(const HomeState()) {
    if (_currentUser != null) {
      getAccount();
      getDonations();
    }
  }

  final DonationRepository _donationRepository;
  final BufeRepository _bufeRepository;
  final UserModel? _currentUser = locator<UserProvider>().user;
  final UsersRepository _usersRepository;

  Future<void> getAccount() async {
    var userId = _currentUser!.id;
    executeApiCall<SumupUserModel>(() => _bufeRepository.getAccount(userId), onSuccess: (data) async {
      state = state.copyWith(account: data);
      if (state.familiyAccounts.isEmpty) getFamily(userId);
      getOrders(userId);
    }, onError: (data) async {
      if (data.contains("404")) {
        executeApiCall<SumupUserModel>(
            () => _bufeRepository.createCustomer(
                fullname: _currentUser!.getFullName(),
                dukappId: _currentUser!.id,
                email: _currentUser!.email ?? ""), onSuccess: (data) async {
          state = state.copyWith(account: data);
          getOrders(userId);
        });
      }
    });
  }

  FutureOr<void> getOrders(num userId) async {
    executeApiCall<Order?>(() => _bufeRepository.getOrders(userId: userId, limit: 10), onSuccess: (data) async {
      if (data != null) {
        state = state.copyWith(orders: data.items);
      }
    });
  }

  FutureOr<void> getFamily(num userId) async {
    executeApiCall<List<UserModel>?>(() => _usersRepository.getChildren(userId), onSuccess: (data) async {
      if (data != null) {
        executeApiCall<String?>(() async {
          state = state.copyWith(familiyAccounts: []);
          for (var user in data) {
            _bufeRepository.getAccount(user.id).then((r) {
              state = state.copyWith(familiyAccounts: [...state.familiyAccounts, r]);
            });
          }
          return "Success";
        });
      }
    });
  }

  @override
  HomeState copyWithState(BaseState status) {
    return state.copyWith(status: status);
  }

  Future<void> getDonations() async {
    try {
      await _donationRepository.getDonations(DateTime.now()).then((data) {
        state = state.copyWith(donations: data);
      });
    } catch (e) {}
  }
}
