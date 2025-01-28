import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/create_transactions/view/create_transactions_layout.dart';

class CreateTransactionPage extends BasePage {
  const CreateTransactionPage({super.key, super.title = "admin_myshare_credits"});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    Future(() {
      if (ref.read(createTransactionsDataProvider).transactionType == TransactionType.POINT) {
        ref
            .watch(createTransactionsDataProvider.notifier)
            .setTransactionTypeAndAccount(TransactionType.CREDIT, Account.MYSHARE);
      }
    });

    return CreateTransactionsLayout(key: key);
  }
}
