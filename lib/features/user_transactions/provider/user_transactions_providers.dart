import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/activity_items/data/repository/activity_items_repository.dart';
import 'package:work_hu/features/activity_items/provider/activity_items_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_items_filter.dart';
import 'package:work_hu/features/transaction_items/data/repository/transaction_items_repository.dart';
import 'package:work_hu/features/transaction_items/providers/transaction_items_provider.dart';
import 'package:work_hu/features/user_transactions/data/model/user_transactions_state.dart';

final userTransactionsDataProvider = StateNotifierProvider.autoDispose<UserTransactionsDataNotifier, UserTransactionsState>(
    (ref) => UserTransactionsDataNotifier(ref.read(transactionItemsRepoProvider), ref.read(activityItemsRepoProvider)));

class UserTransactionsDataNotifier extends BaseDataNotifier<UserTransactionsState> implements ListApiProvider<DateTime> {
  UserTransactionsDataNotifier(
    this.transactionItemsRepository,
    this.activityItemsRepository,
  ) : super(const UserTransactionsState());

  final TransactionItemsRepository transactionItemsRepository;
  final UserModel currentUser = locator<UserProvider>().user!;

  final ActivityItemsRepository activityItemsRepository;

  Future<void> getTransactionItems() async {}

  Future<void> setUserId(num userId) async {
    state = state.copyWith(userId: userId);
    list();
  }

  @override
  Future<void> list({DateTime? filter, int? page, int? size, List<String>? sort}) async {
    if (state.userId != null) {
      await executeApiCall<PaginatedResponse<TransactionItemModel>>(
          () => transactionItemsRepository.getTransactionItems(
              filter: TransactionItemsFilter(
                userId: state.userId,
              ),
              page: page ?? state.listState.number,
              size: size ?? state.listState.size,
              sort: ["transactionDate,desc"]), background: true, onSuccess: ((data) async {
        state = state.copyWith(
            transactionItems: data.page.number == 0 ? data.content : [...state.transactionItems, ...data.content],
            listState: state.listState
                .copyWith(totalElements: data.page.totalElements, totalPages: data.page.totalPages, number: data.page.number));
      }));

      await activityItemsRepository
          .getActivityItems(registeredInApp: false, userId: state.userId)
          .then((acItems) async => state = state.copyWith(activityItems: acItems.content));
    }
  }

  @override
  UserTransactionsState copyWithState(BaseState status) {
    return state = state.copyWith(listState: state.listState.copyWith(baseStatus: status));
  }
}
