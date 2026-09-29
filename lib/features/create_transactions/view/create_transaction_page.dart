import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/create_transactions/data/state/create_transactions_state.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/create_transactions/widget/add_transaction_card.dart';
import 'package:work_hu/features/create_transactions/widget/transaction_details_card.dart';
import 'package:work_hu/features/create_transactions/widget/transaction_row_widget.dart';
import 'package:work_hu/features/create_transactions/widget/transaction_sum_card.dart';

/// Creates MyShare credit transactions. [CreatePointsTransactionPage] and [CreateSamvirkTransactionPage]
/// reuse it for the other transaction types.
class CreateTransactionPage extends BasePage {
  const CreateTransactionPage({
    super.key,
    super.title = "admin_myshare_credits",
    this.transactionType = TransactionType.CREDIT,
    this.account = Account.MYSHARE,
  }) : super(canRefresh: false);

  final TransactionType transactionType;
  final Account account;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return CreateTransactionPageState();
  }
}

class CreateTransactionPageState
    extends BasePageState<CreateTransactionPage, CreateTransactionsState, CreateTransactionsDataNotifier> {
  @override
  void postInit(WidgetRef ref) {
    super.postInit(ref);
    ref
        .read(createTransactionsDataProvider.notifier)
        .setTransactionTypeAndAccount(widget.transactionType, widget.account);
    ref.listenManual(createTransactionsDataProvider, (previous, next) {
      if (previous?.creationState != ModelState.success && next.creationState == ModelState.success && mounted) {
        context.pop();
      }
    });
  }

  @override
  Widget buildLayout() {
    var notifier = ref.watch(createTransactionsDataProvider.notifier);
    return Column(
      children: notifier.descriptionController.value.text.isEmpty
          ? [const TransactionDetailsCard()]
          : _enabledWidgets(),
    );
  }

  List<Widget> _enabledWidgets() {
    var items = state.transactionItems;
    var transactionType = state.transactionType;
    return [
      const TransactionDetailsCard(),
      SizedBox(height: 16.sp),
      TransactionSumCard(items: items),
      SizedBox(height: 16.sp),
      AddTransactionCard(account: state.account),
      SizedBox(height: 16.sp),
      Column(
        children: items.map((e) {
          return TransactionRowWidget(
            name: e.userName,
            index: items.indexOf(e),
            isLast: items.indexOf(e) == items.length - 1,
            value: transactionType == TransactionType.HOURS
                ? e.hours
                : transactionType == TransactionType.CREDIT
                ? e.credit
                : e.points,
          );
        }).toList(),
      ),
      SizedBox(height: 180.sp),
    ];
  }

  @override
  StateNotifierProvider<CreateTransactionsDataNotifier, CreateTransactionsState> get provider =>
      createTransactionsDataProvider;

  @override
  BaseState get status => state.status;
}
