import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/transaction_items/providers/transaction_items_provider.dart';
import 'package:work_hu/features/transaction_items/view/transaction_items_layout.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';

class TransactionItemsPage extends BasePage {
  const TransactionItemsPage(
      {super.key, super.title = "Transaction items", required this.transaction, super.isListView = true});

  final TransactionModel transaction;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return TransactionsLayout(transaction: transaction);
  }

  @override
  Widget? createActionButton(BuildContext context, WidgetRef ref) {
    return transaction.account == Account.MYSHARE ? FloatingActionButton(
      onPressed: () => ref.watch(transactionItemsDataProvider.notifier).createCreditsCsv(),
      child: const Icon(Icons.download),
    ) : null;
  }
}
