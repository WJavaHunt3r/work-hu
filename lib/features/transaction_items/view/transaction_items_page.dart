import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_header_chip.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_items_filter.dart';
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
    extends
        PagedListPageState<
          TransactionItemsPage,
          TransactionItemModel,
          TransactionItemsFilter,
          TransactionItemsDataNotifier
        > {
  @override
  get provider => transactionItemsDataProvider(widget.transactionId);

  @override
  Widget build(BuildContext context) {
    // The base page only reports errors of the list provider.
    ref.listen(transactionDetailProvider(widget.transactionId), (previous, next) {
      if (next.status.modelState.isError && !(previous?.status.modelState.isError ?? false)) {
        Utils.showErrorDialog(context, content: next.status.message.i18n());
      }
    });
    return super.build(context);
  }

  @override
  Widget buildListTile(TransactionItemModel item, int index) {
    return BaseListTile(
      isLast: index == items.length - 1,
      index: index,
      title: Text(item.userName),
      trailing: Text(
        createTrailingText(item),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
      ),
    );
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
  void onDelete(TransactionItemModel item) => notifier.deleteTransactionItem(item.id!);

  @override
  bool canDelete(TransactionItemModel item) => true;

  @override
  List<Widget> buildHeaderLayout(BuildContext context, WidgetRef ref) {
    var transaction = ref.watch(transactionDetailProvider(widget.transactionId)).transaction;
    return [
      BaseHeaderChip(
        label: "transaction_items_date",
        labelValue: () async =>
            transaction == null ? "" : "${transaction.name} - ${Utils.dateFormating(transaction.createDateTime)}",
      ),
      BaseHeaderChip(
        label: "transaction_items_transactionType",
        labelValue: () async => Utils.getTransactionTypeText(transaction?.transactionType),
      ),
      if (transaction?.account == Account.MYSHARE)
        BaseHeaderChip(
          label: "transaction_items_account",
          labelValue: () async => transaction?.transactionType?.name ?? "",
        ),
    ];
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => ref.read(transactionDetailProvider(widget.transactionId).notifier).createCreditsCsv(items),
      child: const Icon(Icons.download),
    );
  }
}
