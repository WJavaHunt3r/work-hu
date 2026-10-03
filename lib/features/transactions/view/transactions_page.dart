import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/providers/locale_provider.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';
import 'package:work_hu/features/transactions/data/models/transactions_filter.dart';
import 'package:work_hu/features/transactions/providers/transactions_provider.dart';
import 'package:work_hu/features/utils.dart';

class TransactionsPage extends BaseListPage {
  const TransactionsPage({super.key, super.title = "admin_transactions"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return TransactionPageState();
  }
}

class TransactionPageState
    extends PagedListPageState<TransactionsPage, TransactionModel, TransactionsFilter, TransactionsDataNotifier> {
  @override
  Widget buildListTile(TransactionModel item, int index) {
    return BaseListTile(
      isLast: items.length - 1 == index,
      index: index,
      onTap: () {
        context.push("/admin/transactions/${item.id}").then((value) => notifier.reload());
      },
      leading: Image.asset(setLeadingIcon(item), fit: BoxFit.fitWidth, width: 15.sp),
      title: Text(item.name),
      subtitle: Text(Utils.dateFormating(item.createDateTime, ref.read(localeProvider).value?.countryCode)),
      trailing: Text(item.transactionCount.toString()),
    );
  }

  @override
  bool canDelete(TransactionModel item) => true;

  @override
  void onDelete(TransactionModel item) => notifier.deleteTransaction(item.id!);

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
  get provider => transactionsDataProvider;

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
