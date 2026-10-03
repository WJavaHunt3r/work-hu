import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/features/rounds/data/api/round_api.dart';
import 'package:work_hu/features/rounds/data/model/round_filter.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/rounds/data/repository/round_repository.dart';
import 'package:work_hu/features/rounds/data/state/round_detail_state.dart';

final roundApiProvider = Provider<RoundApi>((ref) => RoundApi());

final roundRepoProvider = Provider<RoundRepository>((ref) => RoundRepository(ref.read(roundApiProvider)));

final roundDataProvider = StateNotifierProvider.autoDispose<RoundsDataNotifier, PagedState<RoundModel, RoundFilter>>(
  (ref) => RoundsDataNotifier(ref.read(roundRepoProvider)),
);

final roundDetailProvider = StateNotifierProvider.autoDispose<RoundDetailNotifier, RoundDetailState>(
  (ref) => RoundDetailNotifier(ref.read(roundRepoProvider)),
);

class RoundsDataNotifier extends PagedListNotifier<RoundModel, RoundFilter> {
  RoundsDataNotifier(this.roundRepository)
    : super(
        ListQuery(
          filter: RoundFilter(activeRound: true, seasonYear: DateTime.now().year),
          sort: const [SortOrder("startDateTime", SortDir.desc)],
        ),
      );

  final RoundRepository roundRepository;

  @override
  Future<PaginatedResponse<RoundModel>> fetch(ListQuery<RoundFilter> query, int page) =>
      roundRepository.getRounds(query, page: page);
}

class RoundDetailNotifier extends BaseDataNotifier<RoundDetailState> {
  RoundDetailNotifier(this.roundRepository) : super(const RoundDetailState());

  final RoundRepository roundRepository;

  Future<void> getRound(num id) async {
    executeApiCall<RoundModel>(
      () => roundRepository.getRound(id),
      onSuccess: (data) async {
        state = state.copyWith(round: data);
      },
    );
  }

  @override
  RoundDetailState copyWithState(BaseState status) => state.copyWith(status: status);
}
