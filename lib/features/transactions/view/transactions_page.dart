import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/transactions/view/transactions_layout.dart';

class TransactionsPage extends BasePage {
  const TransactionsPage({super.key, super.title = "admin_transactions"});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return TransactionsLayout(key: key);
  }
}
