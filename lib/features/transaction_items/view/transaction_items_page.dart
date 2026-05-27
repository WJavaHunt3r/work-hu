import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/widgets/base_header_chip.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transaction_items/data/state/transaction_items_state.dart';
import 'package:work_hu/features/transaction_items/providers/transaction_items_provider.dart';
import 'package:work_hu/features/utils.dart';

import '../../../app/framework/base_components/base_page_components/base_list_page.dart';

class TransactionItemsPage extends BaseListPage {
  const TransactionItemsPage({super.key, super.title = "transaction_items_title", required this.transactionId});

  final num transactionId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return TransactionItemsPageState();
  }
}

class TransactionItemsPageState
    extends BaseListPageState<TransactionItemsPage, TransactionItemsState, TransactionItemsDataNotifier> {
  @override
  void postInit(WidgetRef ref) {
    ref.read(provider.notifier).getTransaction(widget.transactionId);
  }

  @override
  Widget buildListTile(item) {
    item as TransactionItemModel;
    bool isLast = items.indexOf(item) == items.length - 1;
    return BaseListTile(
        isLast: isLast,
        index: items.indexOf(item),
        title: Text(item.userName),
        trailing: Text(
          createTrailingText(item),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
        ));
  }

  String createTrailingText(TransactionItemModel current) {
    if (current.transactionType == TransactionType.CREDIT) {
      return Utils.creditFormatting(current.credit);
    }
    if (current.transactionType == TransactionType.HOURS || current.account == Account.MYSHARE) {
      return "${Utils.creditFormatting(current.credit)} (${current.hours}h) ";
    }
    return "${Utils.percentFormat.format(current.points)} p";
  }

  @override
  onDelete(e) {
    ref.read(provider.notifier).deleteTransactionItem(e.id!, items.indexOf(e));
  }

  @override
  bool canDelete(item) {
    return true;
  }

  @override
  List<dynamic> getFilters() {
    return [];
  }

  @override
  List<dynamic> get items => state.transactionItems;

  @override
  BaseListState get listStatus => state.listState;

  @override
  get provider => transactionItemsDataProvider;

  @override
  List<Widget> buildHeaderLayout(BuildContext context, WidgetRef ref) {
    var transaction = state.transaction;
    return [
      BaseHeaderChip(
        label: "transaction_items_date",
        labelValue: () async =>
            transaction == null ? "" : "${transaction.name} - ${Utils.dateFormating(transaction.createDateTime)}",
      ),
      BaseHeaderChip(
          label: "transaction_items_transactionType",
          labelValue: () async => Utils.getTransactionTypeText(transaction?.transactionType)),
      if (transaction?.account == Account.MYSHARE)
        BaseHeaderChip(label: "transaction_items_account", labelValue: () async => transaction?.transactionType?.name ?? ""),
    ];
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => ref.read(provider.notifier).createCreditsCsv(),
      child: const Icon(Icons.download),
    );
  }
}
