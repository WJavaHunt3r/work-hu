import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/user_transactions/data/model/user_transactions_state.dart';
import 'package:work_hu/features/user_transactions/provider/user_transactions_providers.dart';
import 'package:work_hu/features/user_transactions/widgets/points_list_item.dart';
import 'package:work_hu/features/utils.dart';

class UserTransactionsPage extends BaseListPage {
  const UserTransactionsPage({super.key, super.title = "user_points_title", required this.userId});

  final num userId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserTransactionsPageState();
  }
}

class UserTransactionsPageState
    extends BaseListPageState<UserTransactionsPage, UserTransactionsState, UserTransactionsDataNotifier> {
  late List<DateTime> dates;

  @override
  void postInit(WidgetRef ref) {
    ref.read(userTransactionsDataProvider.notifier).setUserId(widget.userId);
    dates = createDates();
  }

  @override
  Widget? buildListLayout(BuildContext context, WidgetRef ref) {
    return Column(
      children: buildListTiles(items) as List<Widget>,
    );
  }

  @override
  Widget buildListTile(item) {
    item as TransactionItemModel;
    return TransactionTile(
        title: item.description,
        date: Utils.dateFormating(item.transactionDate),
        amount: Utils.creditFormatting(item.credit),
        transactionType: item.transactionType);
  }

  // @override
  // List<BaseFilterChip> buildFilterLayout(BuildContext context, WidgetRef ref) {
  //   return [
  //     DialogFilterChip<DateTime>(
  //         label: "activity_reference_date",
  //         showDelete: false,
  //         labelValue: (date) =>
  //             "${date?.year ?? state.referenceDate?.year} - ${Utils.getMonthFromDate(date ?? state.referenceDate!, context)}",
  //         onDeleted: () => list(filter: state.copyWith(referenceDate: null)),
  //         initialValue: state.referenceDate,
  //         onItemSelected: (e) => list(filter: state.copyWith(referenceDate: e)),
  //         children: () async => dates,
  //         title: (date) => Text("${date.year} - ${Utils.getMonthFromDate(date, context)}"))
  //   ];
  // }

  List<DateTime> createDates() {
    var dates = <DateTime>[];
    for (var i = DateTime.now().year; i >= 2024; i--) {
      var month = i != DateTime.now().year ? 12 : DateTime.now().month;
      for (var j = month; j >= 1; j--) {
        dates.add(DateTime(i, j, 1));
      }
    }

    return dates;
  }

  @override
  List<dynamic> getFilters() {
    return [];
  }

  @override
  List<TransactionItemModel> get items => state.transactionItems;

  @override
  BaseListState get listStatus => state.listState;

  @override
  StateNotifierProvider<UserTransactionsDataNotifier, UserTransactionsState> get provider =>
      userTransactionsDataProvider;
}
