import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/transactions/data/api/transaction_api.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';
import 'package:work_hu/features/transactions/data/models/transactions_filter.dart';
import 'package:work_hu/features/transactions/data/repository/transactions_repository.dart';

final transactionsApiProvider = Provider<TransactionApi>((ref) => TransactionApi());

final transactionsRepoProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepository(ref.read(transactionsApiProvider)),
);

final transactionsDataProvider =
    StateNotifierProvider.autoDispose<TransactionsDataNotifier, PagedState<TransactionModel, TransactionsFilter>>(
      (ref) => TransactionsDataNotifier(ref.read(transactionsRepoProvider), ref.read(userDataProvider).user),
    );

class TransactionsDataNotifier extends PagedListNotifier<TransactionModel, TransactionsFilter> {
  TransactionsDataNotifier(this.transactionRepository, this.currentUser)
    : super(const ListQuery(filter: TransactionsFilter(), sort: [SortOrder("createDateTime", SortDir.desc)]));

  final TransactionRepository transactionRepository;
  final UserModel? currentUser;

  @override
  Future<PaginatedResponse<TransactionModel>> fetch(ListQuery<TransactionsFilter> query, int page) =>
      transactionRepository.getTransactions(query, page: page);

  Future<void> deleteTransaction(num id) async {
    await executeApiCall(
      () => transactionRepository.deleteTransaction(id, currentUser!.id),
      onSuccess: (_) async => removeItems((transaction) => transaction.id == id),
    );
  }
}
