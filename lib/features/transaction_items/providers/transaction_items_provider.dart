import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/transaction_items/data/api/transaction_items_api.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_items_filter.dart';
import 'package:work_hu/features/transaction_items/data/repository/transaction_items_repository.dart';
import 'package:work_hu/features/transaction_items/data/state/transaction_detail_state.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';
import 'package:work_hu/features/transactions/data/repository/transactions_repository.dart';
import 'package:work_hu/features/transactions/providers/transactions_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

import '../../../app/data/models/transaction_type.dart';
import '../../utils.dart';

final transactionItemsApiProvider = Provider<TransactionItemsApi>((ref) => TransactionItemsApi());

final transactionItemsRepoProvider = Provider<TransactionItemsRepository>(
  (ref) => TransactionItemsRepository(ref.read(transactionItemsApiProvider)),
);

/// The items of one transaction, by transaction id.
final transactionItemsDataProvider = StateNotifierProvider.autoDispose
    .family<TransactionItemsDataNotifier, PagedState<TransactionItemModel, TransactionItemsFilter>, num>(
      (ref, transactionId) => TransactionItemsDataNotifier(
        ref.read(transactionItemsRepoProvider),
        ref.read(userDataProvider).user,
        transactionId,
      ),
    );

/// The transaction whose items are listed, by transaction id.
final transactionDetailProvider = StateNotifierProvider.autoDispose
    .family<TransactionDetailNotifier, TransactionDetailState, num>(
      (ref, transactionId) =>
          TransactionDetailNotifier(ref.read(transactionsRepoProvider), ref.read(usersRepoProvider), transactionId),
    );

class TransactionItemsDataNotifier extends PagedListNotifier<TransactionItemModel, TransactionItemsFilter> {
  TransactionItemsDataNotifier(this.transactionItemsRepository, this.currentUser, num transactionId)
    : super(
        ListQuery(
          filter: TransactionItemsFilter(transactionId: transactionId),
          sort: const [SortOrder("user.lastname"), SortOrder("user.firstname")],
          size: 50,
        ),
      );

  final TransactionItemsRepository transactionItemsRepository;
  final UserModel? currentUser;

  @override
  Future<PaginatedResponse<TransactionItemModel>> fetch(ListQuery<TransactionItemsFilter> query, int page) =>
      transactionItemsRepository.getTransactionItems(query, page: page);

  Future<void> deleteTransactionItem(num id) async {
    await executeApiCall(
      () => transactionItemsRepository.deleteTransactionItem(id, currentUser!.id),
      onSuccess: (_) async => removeItems((item) => item.id == id),
    );
  }
}

class TransactionDetailNotifier extends BaseDataNotifier<TransactionDetailState> {
  TransactionDetailNotifier(this.transactionsRepository, this.usersRepository, num transactionId)
    : super(const TransactionDetailState()) {
    getTransaction(transactionId);
  }

  final TransactionRepository transactionsRepository;
  final UsersRepository usersRepository;

  Future<void> getTransaction(num transactionId) async {
    await executeApiCall<TransactionModel>(
      () => transactionsRepository.getTransaction(transactionId),
      onSuccess: (data) async {
        state = state.copyWith(transaction: data);
      },
    );
  }

  /// Exports [items] (the items loaded so far) as a MyShare credit CSV.
  Future<void> createCreditsCsv(List<TransactionItemModel> items) async {
    var list = <TransactionItemModel>[];
    DateTime date = DateTime.now();
    String desc = "";
    var users = <UserModel>[];
    for (var item in items) {
      users.add(await usersRepository.getUserById(item.userId));
      date = item.transactionDate;
      desc = item.description;
      list.add(
        TransactionItemModel(
          transactionDate: item.transactionDate,
          description: item.description,
          createUserId: item.createUserId,
          points: item.hours * 4,
          transactionType: item.transactionType,
          account: item.account,
          credit: item.transactionType == TransactionType.DUKA_MUNKA
              ? item.hours * 1000
              : item.transactionType == TransactionType.DUKA_MUNKA_2000
              ? item.hours * 2000
              : item.transactionType == TransactionType.HOURS
              ? item.hours * 3000
              : item.transactionType == TransactionType.POINT
              ? 0
              : item.transactionType == TransactionType.CREDIT
              ? item.credit
              : 0,
          hours: item.hours,
          userName: item.userName,
          userId: item.userId,
        ),
      );
    }
    Utils.createCreditCsv(list, date, desc, users);
  }

  @override
  TransactionDetailState copyWithState(BaseState status) => state.copyWith(status: status);
}
