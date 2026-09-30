import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/fra_kare_week/data/api/fra_kare_week_api.dart';
import 'package:work_hu/features/fra_kare_week/data/model/fra_kare_week_model.dart';
import 'package:work_hu/features/fra_kare_week/data/repository/fra_kare_week_repository.dart';

final fraKareWeekApiProvider = Provider<FraKareWeekApi>((ref) => FraKareWeekApi());

final fraKareWeekRepoProvider = Provider<FraKareWeekRepository>(
  (ref) => FraKareWeekRepository(ref.read(fraKareWeekApiProvider)),
);

/// Filtered by year.
final fraKareWeekDataProvider =
    StateNotifierProvider.autoDispose<FraKareWeekDataNotifier, PagedState<FraKareWeekModel, int>>(
      (ref) => FraKareWeekDataNotifier(ref.read(fraKareWeekRepoProvider)),
    );

class FraKareWeekDataNotifier extends PagedListNotifier<FraKareWeekModel, int> {
  FraKareWeekDataNotifier(this.fraKareWeekRepository) : super(ListQuery(filter: DateTime.now().year));

  final FraKareWeekRepository fraKareWeekRepository;

  /// Not paged by the server: returns the whole year at once.
  @override
  Future<PaginatedResponse<FraKareWeekModel>> fetch(ListQuery<int> query, int page) async =>
      PaginatedResponse.all(await fraKareWeekRepository.getFraKareWeeks(year: query.filter));
}
