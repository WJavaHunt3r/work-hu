import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe/data/repository/bufe_repository.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';
import 'package:work_hu/features/bufe_transactions/data/state/bufe_transactions_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

final bufeTransactionsDataProvider = StateNotifierProvider.autoDispose<BufeTransactionsDataNotifier, BufeTransactionsState>(
    (ref) => BufeTransactionsDataNotifier(ref.watch(bufeRepoProvider)));

class BufeTransactionsDataNotifier extends BaseDataNotifier<BufeTransactionsState> implements ListApiProvider<num> {
  BufeTransactionsDataNotifier(this._bufeRepository) : super(const BufeTransactionsState()) {
    if (currentUser != null) {
      list(filter: currentUser!.id);
    }
  }

  final BufeRepository _bufeRepository;
  final UserModel? currentUser = locator<UserProvider>().user;

  @override
  Future<void> list({num? filter, int? page, int? size, List<String>? sort}) async {
    executeApiCall<Order?>(() => _bufeRepository.getOrders(userId: filter ?? 0, page: page ?? state.listStatus.number ,
        limit: size ?? state.listStatus.size), onSuccess: (data) async {
      state = state.copyWith(
          orders: data?.items ?? [],
          listStatus: state.listStatus.copyWith(
              totalElements: data?.total.toInt() ?? 0, size: data?.limit.toInt() ?? 0, number: data?.offset.toInt() ?? 0));
    });
  }

  @override
  BufeTransactionsState copyWithState(BaseState status) {
    return state.copyWith(listStatus: state.listStatus.copyWith(baseStatus: status));
  }
}
