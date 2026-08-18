import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/framework/base_components/page_stru.dart';
import 'package:work_hu/app/framework/base_components/sort_builder.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/features/round_filter_chip/data/state/round_filter_chip_state.dart';
import 'package:work_hu/features/rounds/data/model/round_filter.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/rounds/data/repository/round_repository.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';

final roundFilterChipDataProvider = StateNotifierProvider<RoundFilterChipDataNotifier, RoundFilterChipState>(
    (ref) => RoundFilterChipDataNotifier(ref.read(roundRepoProvider)));

class RoundFilterChipDataNotifier extends BaseDataNotifier<RoundFilterChipState> implements ListApiProvider<RoundFilter> {
  RoundFilterChipDataNotifier(
    this.roundsRepository,
  ) : super(const RoundFilterChipState()){
    getCurrentRound();
  }

  final RoundRepository roundsRepository;
  final Map<String, List<RoundModel>> _cache = {};

  @override
  Future<List<RoundModel>> list({RoundFilter? filter, int? page, int? size, List<String>? sort}) async {
    var cacheKey = filter.toString();
    if (_cache.containsKey(cacheKey)) {
      var list = _cache[cacheKey]!;
      return list;
    }
    var sort = SortBuilder()..add("createDateTime", descending: false);
    state = state.copyWith(filter: filter ?? state.filter);
    try {
      var result = await roundsRepository.getRounds(filter: filter ?? state.filter, pageStru: PageStru(sort: sort.build()));
      _cache[cacheKey] = result.content;

      return result.content;
    } catch (e) {
      return [];
    }
  }

  Future<RoundModel> getCurrentRound() async {
    if(state.currentRound != null){
      return state.currentRound!;
    }
    var round = await executeApiCall<RoundModel>(()=> roundsRepository.getCurrentRounds());

    state = state.copyWith(currentRound: round);
    return round;
  }

  @override
  RoundFilterChipState copyWithState(BaseState status) {
    return state.copyWith(status: state.status.copyWith(baseStatus: status));
  }
}
