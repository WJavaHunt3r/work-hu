import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/transaction_items/providers/transaction_items_provider.dart';
import 'package:work_hu/features/transactions/data/models/transaction_model.dart';
import 'package:work_hu/features/transactions/providers/transactions_provider.dart';
import 'package:work_hu/features/utils.dart';

class TransactionsLayout extends ConsumerWidget {
  const TransactionsLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var transactions = ref.watch(transactionsDataProvider).transactions;
    return Stack(children: [
      RefreshIndicator(
        onRefresh: () async => ref.read(transactionsDataProvider.notifier).getTransactions(),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(top: 4.sp, bottom: 4.sp),
            child: DropdownButtonFormField<RoundModel>(
                decoration: InputDecoration(labelText: "transactions_round".i18n()),
                value: ref.watch(transactionsDataProvider).rounds.isEmpty
                    ? null
                    : ref
                        .watch(transactionsDataProvider)
                        .rounds
                        .firstWhere((r) => r.id == ref.watch(transactionsDataProvider).selectedRoundId),
                items: ref
                    .watch(transactionsDataProvider)
                    .rounds
                    .map((e) => DropdownMenuItem<RoundModel>(
                          value: e,
                          child: Text("${e.season.seasonYear.toString()}/${e.roundNumber}"),
                        ))
                    .toList(),
                onChanged: (value) => ref.watch(transactionsDataProvider.notifier).setSelectedRound(value?.id ?? 0)),
          ),
          Expanded(
              child: BaseListView(
            itemBuilder: (BuildContext context, int index) {
              var current = transactions[index];
              var date = current.createDateTime;
              var dateString = Utils.dateToString(date!);
              return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) => showDialog(
                          context: context,
                          builder: (buildContext) {
                            return ConfirmAlertDialog(
                              onConfirm: () => buildContext.pop(true),
                              title: "delete".i18n(),
                              content: Text("transactions_delete_warning".i18n(), textAlign: TextAlign.center),
                            );
                          })
                      .then((confirmed) => confirmed != null && confirmed
                          ? ref.read(transactionsDataProvider.notifier).deleteTransaction(current.id!, index)
                          : null),
                  dismissThresholds: const <DismissDirection, double>{DismissDirection.endToStart: 0.4},
                  child: Card(
                    margin: const EdgeInsets.all(0),
                    child: BaseListTile(
                      isLast: transactions.length - 1 == index,
                      index: index,
                      onTap: () {
                        ref.watch(transactionItemsDataProvider.notifier).getTransaction(current.id!);
                        context
                            .push("/admin/transactions/${current.id}")
                            .then((value) => ref.watch(transactionsDataProvider.notifier).getTransactions());
                      },
                      leading: Image(
                        image: AssetImage(setLeadingIcon(current)),
                        fit: BoxFit.fitWidth,
                        width: 15.sp,
                      ),
                      title: Text(current.name),
                      subtitle: Text(dateString),
                      trailing: Text(current.transactionCount.toString()),
                    ),
                  ));
            },
            itemCount: ref.watch(transactionsDataProvider).transactions.length,
            shadowColor: Colors.transparent,
            cardBackgroundColor: Colors.transparent,
            children: const [],
          ))
        ]),
      ),
      ref.watch(transactionsDataProvider).modelState == ModelState.error
          ? Center(
              child: Text(
                ref.watch(transactionsDataProvider).message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.errorRed),
              ),
            )
          : const SizedBox(),
      ref.watch(transactionsDataProvider).modelState == ModelState.processing
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox()
    ]);
  }

  String setLeadingIcon(TransactionModel current) {
    if (current.account == Account.MYSHARE) {
      return "assets/img/myshare-logo.png";
    }
    if (current.account == Account.SAMVIRK) {
      return "assets/img/Samvirk_logo.png";
    }
    return "assets/img/WORK_Logo_01_RGB.png";
  }
}
