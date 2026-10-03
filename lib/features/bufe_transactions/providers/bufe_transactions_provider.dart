import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe/data/repository/bufe_repository.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';

/// Filtered by user id.
final bufeTransactionsDataProvider =
    StateNotifierProvider.autoDispose<BufeTransactionsDataNotifier, PagedState<OrderEntry, num>>(
      (ref) => BufeTransactionsDataNotifier(ref.watch(bufeRepoProvider), ref.read(userDataProvider).user?.id ?? 0),
    );

class BufeTransactionsDataNotifier extends PagedListNotifier<OrderEntry, num> {
  BufeTransactionsDataNotifier(this._bufeRepository, num userId) : super(ListQuery(filter: userId, size: 50));

  final BufeRepository _bufeRepository;

  @override
  Future<PaginatedResponse<OrderEntry>> fetch(ListQuery<num> query, int page) async {
    final data = await _bufeRepository.getOrders(userId: query.filter, limit: query.size, page: page);
    return PaginatedResponse.fromOffset(
      content: data.items,
      offset: data.offset.toInt(),
      limit: data.limit.toInt(),
      total: data.total.toInt(),
    );
  }
}
