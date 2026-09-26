import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/rounds/data/repository/round_repository.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/transactions/data/api/transaction_api.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';
import 'package:work_hu/features/transactions/data/models/transactions_filter.dart';
import 'package:work_hu/features/transactions/data/repository/transactions_repository.dart';
import 'package:work_hu/features/transactions/data/state/transactions_state.dart';

import '../../../app/framework/base_components/page_stru.dart';

final transactionsApiProvider = Provider<TransactionApi>((ref) => TransactionApi());

final transactionsRepoProvider =
    Provider<TransactionRepository>((ref) => TransactionRepository(ref.read(transactionsApiProvider)));

final transactionsDataProvider = StateNotifierProvider.autoDispose<TransactionsDataNotifier, TransactionsState>((ref) =>
    TransactionsDataNotifier(ref.read(transactionsRepoProvider), ref.read(userDataProvider).user, ref.read(roundRepoProvider)));

class TransactionsDataNotifier extends BaseDataNotifier<TransactionsState> implements ListApiProvider<TransactionsFilter> {
  TransactionsDataNotifier(this.transactionRepository, this.currentUser, this.roundRepository)
      : super(const TransactionsState(listState: BaseListState(sort: ["createDateTime,desc"]))){
    list();
  }

  final TransactionRepository transactionRepository;
  final UserModel? currentUser;
  final RoundRepository roundRepository;

  @override
  Future<void> list({TransactionsFilter? filter, int? page, int? size, List<String>? sort}) async {
    await executeApiCall<PaginatedResponse<TransactionModel>>(
        () => transactionRepository.getTransactions(
            filter: filter ?? state.filter,
            pageStru: PageStru(
                page: page ?? state.listState.number,
                size: size ?? state.listState.size,
                sort: sort ?? state.listState.sort)), onSuccess: (data) async {
      state = state.copyWith(
          transactions: page == 0 ? data.content : [...state.transactions, ...data.content],
          listState: state.listState
              .copyWith(totalElements: data.page.totalElements, totalPages: data.page.totalPages, number: data.page.number));
    });
  }

  Future<void> deleteTransaction(num id, int index) async {
    await transactionRepository.deleteTransaction(id, currentUser!.id).then((data) {
      List<TransactionModel> items = [];
      for (var i = 0; i < state.transactions.length; i++) {
        if (i != index) items.add(state.transactions[i]);
      }
      state = state.copyWith(transactions: items);
    });
  }


  @override
  TransactionsState copyWithState(BaseState status) {
    return state.copyWith(listState: state.listState.copyWith(baseStatus: status));
  }
}
