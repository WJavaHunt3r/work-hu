import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/create_transactions/view/create_forbilde_transaction_layout.dart';
import 'package:work_hu/features/create_transactions/view/create_transactions_layout.dart';

class CreateTransactionsPage extends ConsumerWidget {
  const CreateTransactionsPage(
      {super.key,
      required this.transactionId,
      required this.description,
      required this.transactionType,
      required this.account});

  final num transactionId;
  final TransactionType transactionType;
  final Account account;
  final String description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String title = getTitle();
    Future(() => ref.read(createTransactionsDataProvider.notifier).getUsers(
        transactionId: transactionId, transactionType: transactionType, account: account, description: description));
    return PopScope(
        canPop: false,
        onPopInvoked: (value) => context.pop(value),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              title,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(12.sp),
            child: transactionType == TransactionType.VAER_ET_FORBILDE
                ? CreateForbildeTransactionLayout(transactionId: transactionId)
                : CreateTransactionsLayout(
                    transactionId: transactionId, transactionType: transactionType, account: account),
          ),
        ));
  }

  String getTitle() {
    if (account == Account.OTHER) {
      if (transactionType == TransactionType.VAER_ET_FORBILDE) {
        return "Vær et forbilde points";
      }
      return "Points";
    } else if (account == Account.SAMVIRK) {
      return "Samvirk credits";
    } else if (account == Account.MYSHARE) {
      if (transactionType == TransactionType.HOURS) {
        return "MyShare hours";
      } else {
        return "MyShare credits";
      }
    }
    return "";
  }
}
