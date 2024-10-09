import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/create_transactions/view/create_bmm_transaction_layout.dart';

class CreateBmmTransactionPage extends BasePage {
  const CreateBmmTransactionPage({super.key, super.title = "admin_bmm_perfect_weeks"});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    Future(() {
      if (ref.read(createTransactionsDataProvider).transactionType == TransactionType.POINT) {
        ref
            .watch(createTransactionsDataProvider.notifier)
            .setTransactionTypeAndAccount(TransactionType.BMM_PERFECT_WEEK, Account.OTHER);
      }
    });

    return CreateBMMTransactionLayout(
      key: key,
    );
  }
}
