import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/work_drop_down_dearch_form_field.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/profile/widgets/info_card.dart';
import 'package:work_hu/features/utils.dart';

class AddTransactionCard extends ConsumerWidget {
  const AddTransactionCard({
    super.key,
    required this.account,
  });

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isError = ref
        .watch(createTransactionsDataProvider)
        .modelState == ModelState.error;
    return InfoCard(
        padding: 8.sp,
        height: isError ? 210.sp : 130.sp,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WorkDropDownSearchFormField<UserModel>(
              focusNode: ref
                  .watch(createTransactionsDataProvider.notifier)
                  .usersFocusNode,
              direction: AxisDirection.up,
              controller: ref
                  .read(createTransactionsDataProvider.notifier)
                  .userController,
              autofocus: true,
              onSuggestionSelected: (UserModel suggestion) =>
                  ref.read(createTransactionsDataProvider.notifier).updateSelectedUser(suggestion),
              itemBuilder: (context, data) => Text("${data.getFullName()} (${data.getAge()})"),
              suggestionsCallback: (String pattern) =>
                  ref.read(createTransactionsDataProvider.notifier).filterUsers(pattern),
            ),
            SizedBox(height: 10.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 150.sp,
                    child: TextField(
                      controller: ref
                          .read(createTransactionsDataProvider.notifier)
                          .valueController,
                      keyboardType: TextInputType.number,
                      focusNode: ref
                          .read(createTransactionsDataProvider.notifier)
                          .valueFocusNode,
                      textInputAction: TextInputAction.send,
                      onSubmitted: ref
                          .watch(createTransactionsDataProvider)
                          .selectedUser != null &&
                          ref
                              .watch(createTransactionsDataProvider.notifier)
                              .valueController
                              .value
                              .text
                              .isNotEmpty
                          ? (text) => ref.read(createTransactionsDataProvider.notifier).addTransaction()
                          : null,
                      decoration: InputDecoration(
                          labelText:
                          Utils.getTransactionTypeText(ref
                              .watch(createTransactionsDataProvider)
                              .transactionType)),
                    )),
                TextButton(
                    onPressed: ref
                        .watch(createTransactionsDataProvider)
                        .selectedUser != null &&
                        ref
                            .watch(createTransactionsDataProvider.notifier)
                            .valueController
                            .value
                            .text
                            .isNotEmpty
                        ? () => ref.read(createTransactionsDataProvider.notifier).addTransaction()
                        : null,
                    // style: ButtonStyle(
                    //   side: WidgetStateBorderSide.resolveWith(
                    //     (states) {
                    //       if (states.contains(WidgetState.disabled)) {
                    //         return BorderSide(color: Colors.grey.shade300, width: 2.sp);
                    //       }
                    //       return BorderSide(color: AppColors.primary, width: 2.sp);
                    //     },
                    //   ),
                    //   backgroundColor: WidgetStateColor.resolveWith((states) {
                    //     if (states.contains(WidgetState.disabled)) {
                    //       return Colors.grey.shade300;
                    //     }
                    //     return AppColors.primary;
                    //   }),
                    // ),
                    child: const Icon(
                      Icons.add,
                      color: AppColors.white,
                    ))
              ],
            ),
            isError
                ? Padding(
              padding: EdgeInsets.only(top: 8.sp, left: 8.sp, right: 8.sp),
              child: Text(
                ref
                    .watch(createTransactionsDataProvider)
                    .message,
                style: const TextStyle(color: AppColors.errorRed),
              ),
            )
                : const SizedBox(),
          ],
        ));
  }
}
