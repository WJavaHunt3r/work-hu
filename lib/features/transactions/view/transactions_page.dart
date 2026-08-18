import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/providers/localeProvider.dart';
import 'package:work_hu/app/widgets/base_filter_chip.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';
import 'package:work_hu/features/transactions/data/state/transactions_state.dart';
import 'package:work_hu/features/transactions/providers/transactions_provider.dart';
import 'package:work_hu/features/utils.dart';

class TransactionsPage extends BaseListPage {
  const TransactionsPage({super.key, super.title = "admin_transactions"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return TransactionPageState();
  }
}

class TransactionPageState extends BaseListPageState<TransactionsPage, TransactionsState, TransactionsDataNotifier> {
  @override
  Widget buildListTile(item) {
    item as TransactionModel;
    var index = items.indexOf(item);
    return BaseListTile(
      isLast: items.length - 1 == index,
      index: index,
      onTap: () {
        context.push("/admin/transactions/${item.id}").then((value) => list());
      },
      leading: Image.asset(
        setLeadingIcon(item),
        fit: BoxFit.fitWidth,
        width: 15.sp,
      ),
      title: Text(item.name),
      subtitle: Text(Utils.dateFormating(item.createDateTime, ref.read(localeProvider).value?.countryCode)),
      trailing: Text(item.transactionCount.toString()),
    );
  }

  @override
  canDelete(item) {
    return true;
  }

  @override
  onDelete(e) {
    e as TransactionModel;
    ref.read(provider.notifier).deleteTransaction(e.id!, items.indexOf(e));
  }

  String setLeadingIcon(TransactionModel current) {
    if (current.account == Account.MYSHARE) {
      return "assets/img/myshare-logo.png";
    }
    if (current.account == Account.SAMVIRK) {
      return "assets/img/Samvirk_logo.png";
    }
    return "assets/img/BUK_black_circle.png";
  }

  @override
  List<dynamic> getFilters() {
    return [];
  }

  @override
  List<TransactionModel> get items => state.transactions;

  @override
  BaseListState get listStatus => state.listState;

  @override
  AutoDisposeStateNotifierProvider<TransactionsDataNotifier, TransactionsState> get provider => transactionsDataProvider;

  // @override
  // List<BaseFilterChip> buildFilterLayout(BuildContext context, WidgetRef ref) {
  //   return [
  //     DialogFilterChip<DateTime?>(
  //         label: "activity_reference_date",
  //         showDelete: false,
  //         labelValue: (date) =>
  //         "${date?.year ?? state.filter.referenceDate?.year} - ${Utils.getMonthFromDate(date ?? state.filter.referenceDate!, context)}",
  //         onDeleted: () => list(filter: state.filter.copyWith(referenceDate: null)),
  //         initialValue: state.filter.referenceDate,
  //         onItemSelected: (e) => list(filter: state.filter.copyWith(referenceDate: e)),
  //         children: () async => dates,
  //         title: (date) => date == null ? Text("") : Text("${date.year} - ${Utils.getMonthFromDate(date, context)}"))
  //   ];
  // }
}
