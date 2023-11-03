import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
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
    var isError = ref.watch(createTransactionsDataProvider).modelState == ModelState.error;
    return InfoCard(
        padding: 8.sp,
        height: isError ? 150.sp : 120.sp,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownSearch<UserModel>(
                asyncItems: (filter) => ref.read(createTransactionsDataProvider.notifier).filterUsers(filter),
                selectedItem: ref.read(createTransactionsDataProvider).selectedUser,
                onChanged: (user) => ref.read(createTransactionsDataProvider.notifier).updateSelectedUser(user),
                itemAsString: (user) =>
                    "${user.lastname} ${user.firstname} (${(DateTime.now().difference(user.birthDate).inDays / 365).ceil() - 1})",
                popupProps: const PopupProps.menu(showSearchBox: true, searchDelay: Duration(milliseconds: 500))),
            SizedBox(height: 10.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 150.sp,
                    child: TextField(
                      controller: ref.read(createTransactionsDataProvider.notifier).valueController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText:
                              Utils.getTransactionTypeText(ref.watch(createTransactionsDataProvider).transactionType)),
                    )),
                TextButton(
                    onPressed: ref.watch(createTransactionsDataProvider).selectedUser != null &&
                            ref.watch(createTransactionsDataProvider.notifier).valueController.value.text.isNotEmpty
                        ? () => ref.read(createTransactionsDataProvider.notifier).addTransaction()
                        : null,
                    style: ButtonStyle(
                      side: MaterialStateBorderSide.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.disabled)) {
                            return BorderSide(color: Colors.grey.shade300, width: 2.sp);
                          }
                          return BorderSide(color: AppColors.primary, width: 2.sp);
                        },
                      ),
                      backgroundColor: MaterialStateColor.resolveWith((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey.shade300;
                        }
                        return AppColors.primary;
                      }),
                    ),
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
                      ref.watch(createTransactionsDataProvider).message,
                      style: const TextStyle(color: AppColors.errorRed),
                    ),
                  )
                : const SizedBox(),
          ],
        ));
  }
}
