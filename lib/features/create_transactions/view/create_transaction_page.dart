import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/create_transactions/view/create_bmm_transaction_layout.dart';
import 'package:work_hu/features/create_transactions/view/create_transactions_layout.dart';

class CreateTransactionPage extends BasePage {
  const CreateTransactionPage(
      {required this.transactionType, required this.account, super.key, super.title = "admin_myshare_credits"});

  final TransactionType transactionType;
  final Account account;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    Future(() {
      if (ref.read(createTransactionsDataProvider).modelState == ModelState.empty) {
        ref.watch(createTransactionsDataProvider.notifier).setTransactionTypeAndAccount(transactionType, account);
        ref.watch(createTransactionsDataProvider.notifier).getUsers();
      }
    });

    return transactionType == TransactionType.BMM_PERFECT_WEEK
        ? CreateBMMTransactionLayout(
            key: key,
          )
        : CreateTransactionsLayout(key: key);
  }
}
