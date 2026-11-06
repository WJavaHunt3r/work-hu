import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/cache/user_data_cache.dart';
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
  (ref) => HomeDataNotifier(ref.watch(bufeRepoProvider), ref.read(donationRepoProvider), ref.read(usersRepoProvider)),
);

class HomeDataNotifier extends BaseDataNotifier<HomeState> {
  HomeDataNotifier(this._bufeRepository, this._donationRepository, this._usersRepository) : super(_cached()) {
    if (_currentUser != null) {
      getAccount();
      getDonations();
    }
  }

  final DonationRepository _donationRepository;
  final BufeRepository _bufeRepository;
  final UserModel? _currentUser = locator<UserProvider>().user;
  final UsersRepository _usersRepository;

  /// The balance, orders, family accounts and pictures the user saw last time ([UserDataCache.balance]), shown until
  /// the API answers.
  static HomeState _cached() {
    return UserDataCache.instance.parse(
          locator<UserProvider>().user?.id,
          UserDataCache.balance,
          (json) => HomeState(
            account: SumupUserModel.fromJson(json['account']),
            orders: [for (final o in json['orders'] as List) OrderEntry.fromJson(o)],
            familiyAccounts: [for (final a in json['familyAccounts'] as List) SumupUserModel.fromJson(a)],
            dukappImages: [for (final i in json['images'] as List) DukappImages.fromJson(i)],
          ),
        ) ??
        const HomeState();
  }

  /// With a balance on screen (cached or loaded before) the requests run in the background: no loading overlay, no
  /// error dialog, and a failure keeps what is shown.
  bool get _background => state.account != null;

  void _save() {
    final account = state.account;
    if (account == null) return;
    UserDataCache.instance.write(_currentUser?.id, UserDataCache.balance, {
      'account': account,
      'orders': state.orders,
      'familyAccounts': state.familiyAccounts,
      'images': state.dukappImages,
    });
  }

  Future<void> getAccount() async {
    var userId = _currentUser!.id;
    final background = _background;
    executeApiCall<SumupUserModel>(
      () => _bufeRepository.getAccount(userId),
      background: background,
      onSuccess: (data) async {
        if (!mounted) return;
        state = state.copyWith(account: data);
        _save();
        _syncBirthDate(data);
        getFamily(userId);
        getOrders(userId);
        getImages();
      },
      onError: (data) async {
        if (data.contains("404")) {
          executeApiCall<SumupUserModel>(
            () => _bufeRepository.createCustomer(
              fullname: _currentUser.getFullName(),
              dukappId: _currentUser.id,
              email: _currentUser.email ?? "",
              birthDate: _currentUser.birthDate,
            ),
            background: background,
            onSuccess: (data) async {
              if (!mounted) return;
              state = state.copyWith(account: data);
              _save();
              getOrders(userId);
            },
          );
        }
      },
    );
  }

  /// Customers created before the kiosk took birth dates have none, and it can't sell them age-restricted products:
  /// fill it in (or correct it) quietly; a failure is tried again next time.
  Future<void> _syncBirthDate(SumupUserModel account) async {
    final user = _currentUser;
    if (user == null) return;
    try {
      final updated = await _bufeRepository.syncBirthDate(user, account);
      if (updated != null && mounted) state = state.copyWith(account: updated);
    } catch (_) {
      // not now
    }
  }

  FutureOr<void> getOrders(num userId) async {
    executeApiCall<Order?>(
      () => _bufeRepository.getOrders(userId: userId, limit: 10),
      background: _background,
      onSuccess: (data) async {
        if (data != null && mounted) {
          state = state.copyWith(orders: data.items);
          _save();
        }
      },
    );
  }

  FutureOr<void> getImages() async {
    executeApiCall<List<DukappImages>>(
      () => _bufeRepository.getDukappImages(),
      background: _background,
      onSuccess: (data) async {
        if (!mounted) return;
        state = state.copyWith(dukappImages: data);
        _save();
      },
    );
  }

  FutureOr<void> getFamily(num userId) async {
    executeApiCall<List<UserModel>?>(
      () => _usersRepository.getChildren(userId),
      background: _background,
      onSuccess: (data) async {
        if (data == null) return;
        // All at once, so the cached accounts stay on screen until the new ones are there
        final accounts = <SumupUserModel>[];
        for (final r in await Future.wait(data.map((user) => _childAccount(user.id)))) {
          if (r != null) accounts.add(r);
        }
        if (!mounted) return;
        state = state.copyWith(familiyAccounts: accounts);
        _save();
      },
    );
  }

  Future<SumupUserModel?> _childAccount(num userId) async {
    try {
      return await _bufeRepository.getAccount(userId);
    } catch (_) {
      // A child without an account
      return null;
    }
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
    } catch (_) {
      // Donations are optional on this page; keep the current list.
    }
  }
}
