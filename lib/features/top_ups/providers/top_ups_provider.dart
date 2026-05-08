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
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/top_ups/data/state/top_ups_state.dart';

final topUpsDataProvider =
    StateNotifierProvider.autoDispose<TopUpsDataNotifier, TopUpsState>((ref) => TopUpsDataNotifier(ref.watch(bufeRepoProvider)));

class TopUpsDataNotifier extends BaseDataNotifier<TopUpsState> implements ListApiProvider<num>{
  TopUpsDataNotifier(this._bufeRepository) : super(const TopUpsState()) {
    if (currentUser != null) {
      list(filter: currentUser!.id);
    }
  }

  final BufeRepository _bufeRepository;
  final UserModel? currentUser = locator<UserProvider>().user;

  @override
  Future<void> list({num? filter, int? page, int? size, String? sort}) async {
    executeApiCall<TopUpResponse?>(() => _bufeRepository.getPayments(userId: filter ?? 0), onSuccess: (data) async {
      state = state.copyWith(
          topUps: data?.items ?? [],
          listStatus:
              state.listStatus.copyWith(totalElements: data?.total ?? 0, size: data?.limit ?? 0, number: data?.offset ?? 0));
    });
  }

  @override
  TopUpsState copyWithState(BaseState status) {
    return state.copyWith(listStatus: state.listStatus.copyWith(baseStatus: status));
  }

}
