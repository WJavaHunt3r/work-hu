import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/error_alert_dialog.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/profile/widgets/info_card.dart';

class CreateTransactionsLayout extends ConsumerWidget {
  const CreateTransactionsLayout(
      {required this.transactionId, required this.transactionType, required this.account, super.key});

  final num transactionId;
  final TransactionType transactionType;
  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var users = ref.watch(createTransactionsDataProvider).users;
    var items = ref.watch(createTransactionsDataProvider).transactionItems;
    return Stack(children: [
      Column(children: [
        InfoCard(
            height: 80.sp,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("count: ${items.length.toStringAsFixed(0)}"),
                Text("sum: ${ref.watch(createTransactionsDataProvider).sum.toString()}"),
                TextButton(
                    onPressed: () => ref.watch(createTransactionsDataProvider.notifier).isEmpty()
                        ? showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return const ErrorAlertDialog(title: "Add at least one transaction!");
                            })
                        : ref.read(createTransactionsDataProvider.notifier).sendTransactions(),
                    style: ButtonStyle(
                      side: MaterialStateBorderSide.resolveWith(
                        (states) => BorderSide(color: AppColors.primary, width: 2.sp),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                    ),
                    child: const Text("Send", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)))
              ],
            )),
        const AddTransaction(),
        Expanded(
            child: ListView.separated(
          itemCount: ref.watch(createTransactionsDataProvider).transactionItems.length,
          itemBuilder: (BuildContext context, int index) {
            var user = users.firstWhere((u) => u.id == items[index].userId);
            return TransactionRow(
              name: "${user.firstname} ${user.lastname}",
              index: index,
              value: transactionType == TransactionType.HOURS
                  ? items[index].hours
                  : transactionType == TransactionType.CREDIT
                      ? items[index].credit
                      : items[index].points,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsets.only(left: 20.sp, right: 20.sp, top: 10.sp, bottom: 10.sp),
                child: Container(
                  height: 1.5.sp,
                  color: AppColors.primary,
                ));
          },
        )),
      ]),
      ref.watch(createTransactionsDataProvider).modelState == ModelState.processing
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const SizedBox(),
    ]);
  }
}

class TransactionRow extends StatelessWidget {
  const TransactionRow({super.key, required this.index, required this.name, required this.value});

  final num index;
  final String name;
  final num value;

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text((index + 1).toString(), style: style),
        Text(name, style: style),
        Text(
          value.toStringAsFixed(0),
          style: style,
        )
      ],
    );
  }
}

class AddTransaction extends ConsumerWidget {
  const AddTransaction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var users = ref.watch(createTransactionsDataProvider).users;
    return InfoCard(
        height: 130.sp,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownSearch<UserModel>(
              items: users,
              selectedItem: ref.read(createTransactionsDataProvider).selectedUser,
              onChanged: (user) => ref.read(createTransactionsDataProvider.notifier).updateSelectedUser(user),
              itemAsString: (user) => "${user.lastname} ${user.firstname}",
            ),
            SizedBox(height: 10.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 150.sp,
                    child: TextField(
                      controller: ref.read(createTransactionsDataProvider.notifier).valueController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Value"),
                    )),
                TextButton(
                    onPressed: ref.watch(createTransactionsDataProvider).selectedUser != null &&
                            ref.watch(createTransactionsDataProvider.notifier).valueController.value.text.isNotEmpty
                        ? () => ref.read(createTransactionsDataProvider.notifier).addTransaction()
                        : null,
                    child: const Icon(
                      Icons.add,
                      color: AppColors.white,
                    ))
              ],
            )
          ],
        ));
  }
}
