import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/framework/base_components/page_stru.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/framework/base_components/sort_builder.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/features/rounds/data/api/round_api.dart';
import 'package:work_hu/features/rounds/data/model/round_filter.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/rounds/data/repository/round_repository.dart';
import 'package:work_hu/features/rounds/data/state/rounds_state.dart';

final roundApiProvider = Provider<RoundApi>((ref) => RoundApi());

final roundRepoProvider = Provider<RoundRepository>((ref) => RoundRepository(ref.read(roundApiProvider)));

final roundDataProvider =
    StateNotifierProvider.autoDispose<RoundsDataNotifier, RoundsState>((ref) => RoundsDataNotifier(ref.read(roundRepoProvider)));

class RoundsDataNotifier extends BaseDataNotifier<RoundsState> implements ListApiProvider<RoundFilter> {
  RoundsDataNotifier(this.roundRepository)
      : super(RoundsState(filter: RoundFilter(activeRound: true, seasonYear: DateTime.now().year))) {
    list();
  }

  final RoundRepository roundRepository;

  @override
  Future<void> list({RoundFilter? filter, int? page, int? size, List<String>? sort}) async {
    var sort = SortBuilder()..add("startDateTime", descending: true);
    executeApiCall<PaginatedResponse<RoundModel>>(
        (() => roundRepository.getRounds(
            filter: filter ?? state.filter,
            pageStru: PageStru(page: page ?? state.status.number, size: size ?? state.status.size, sort: sort.build()))),
        onSuccess: (data) async {
      state = state.copyWith(
          rounds: page == 0 ? data.content : [...state.rounds, ...data.content],
          status: state.status
              .copyWith(totalElements: data.page.totalElements, totalPages: data.page.totalPages, number: data.page.number));
    });
  }

  @override
  RoundsState copyWithState(BaseState status) {
    return state.copyWith(status: state.status.copyWith(baseStatus: status));
  }

  Future<void> getRound(id) async {
    executeApiCall<RoundModel>(() => roundRepository.getRound(id), onSuccess: (data) async {
      state = state.copyWith(selectedRound: data);
    });
  }
}
