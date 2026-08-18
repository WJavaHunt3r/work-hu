import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/app/widgets/work_drop_down_dearch_form_field.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/profile/widgets/info_card.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/user_combo/view/user_combo.dart';
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
    return BaseContainer(
        padding: EdgeInsets.all(8.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserComboWidget(
              controller: ref.watch(createTransactionsDataProvider.notifier).userController,
              onSuggestionSelected: (UserComboModel suggestion) =>
                  ref.read(createTransactionsDataProvider.notifier).updateSelectedUser(suggestion),
              labelText: "create_activity_user".i18n(),
            ),
            SizedBox(height: 10.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150.sp,
                  child: BaseTextFormField(
                      controller: ref.read(createTransactionsDataProvider.notifier).valueController,
                      keyBoardType: TextInputType.number,
                      focusNode: ref.read(createTransactionsDataProvider.notifier).valueFocusNode,
                      textInputAction: TextInputAction.send,
                      onFieldSubmitted: ref.watch(createTransactionsDataProvider).selectedUser != null &&
                              ref.watch(createTransactionsDataProvider.notifier).valueController.value.text.isNotEmpty
                          ? (text) => ref
                              .read(createTransactionsDataProvider.notifier)
                              .addTransaction()
                              .then((r) => ref.read(createTransactionsDataProvider.notifier).usersFocusNode.requestFocus())
                          : null,
                      labelText: Utils.getTransactionTypeText(ref.watch(createTransactionsDataProvider).transactionType)),
                ),
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
