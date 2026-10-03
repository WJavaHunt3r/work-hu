import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_items_filter.dart';
import 'package:work_hu/features/transaction_items/data/repository/transaction_items_repository.dart';
import 'package:work_hu/features/transaction_items/providers/transaction_items_provider.dart';

/// A user's transaction items, by user id.
final userTransactionsDataProvider = StateNotifierProvider.autoDispose
    .family<UserTransactionsDataNotifier, PagedState<TransactionItemModel, TransactionItemsFilter>, num>(
      (ref, userId) => UserTransactionsDataNotifier(ref.read(transactionItemsRepoProvider), userId),
    );

class UserTransactionsDataNotifier extends PagedListNotifier<TransactionItemModel, TransactionItemsFilter> {
  UserTransactionsDataNotifier(this.transactionItemsRepository, num userId)
    : super(
        ListQuery(
          filter: TransactionItemsFilter(userId: userId),
          sort: const [SortOrder("transactionDate", SortDir.desc)],
        ),
      );

  final TransactionItemsRepository transactionItemsRepository;

  @override
  Future<PaginatedResponse<TransactionItemModel>> fetch(ListQuery<TransactionItemsFilter> query, int page) =>
      transactionItemsRepository.getTransactionItems(query, page: page);
}
