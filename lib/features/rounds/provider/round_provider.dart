import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/rounds/data/api/round_api.dart';
import 'package:work_hu/features/rounds/data/model/round_filter.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/rounds/data/repository/round_repository.dart';

final roundApiProvider = Provider<RoundApi>((ref) => RoundApi());

final roundRepoProvider = Provider<RoundRepository>((ref) => RoundRepository(ref.read(roundApiProvider)));

final roundDataProvider = StateNotifierProvider.autoDispose<RoundsDataNotifier, PagedState<RoundModel, RoundFilter>>(
  (ref) => RoundsDataNotifier(ref.read(roundRepoProvider)),
);

class RoundsDataNotifier extends PagedListNotifier<RoundModel, RoundFilter> {
  RoundsDataNotifier(this.roundRepository)
    : super(
        ListQuery(
          // All rounds, also the inactive ones: they can be set active again in the edit form
          filter: RoundFilter(),
          sort: const [SortOrder("startDateTime", SortDir.desc)],
        ),
      );

  final RoundRepository roundRepository;

  @override
  Future<PaginatedResponse<RoundModel>> fetch(ListQuery<RoundFilter> query, int page) =>
      roundRepository.getRounds(query, page: page);
}
