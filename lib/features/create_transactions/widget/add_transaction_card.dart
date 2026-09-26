import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
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
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: UserComboWidget(
                controller: ref.read(createTransactionsDataProvider.notifier).userController,
                focusNode: ref.read(createTransactionsDataProvider.notifier).usersFocusNode,
                onSuggestionSelected: (UserComboModel suggestion) async{
                  await ref.read(createTransactionsDataProvider.notifier).updateSelectedUser(suggestion);
                  ref.read(createTransactionsDataProvider.notifier).valueFocusNode.requestFocus();
                },
                labelText: "create_activity_user".i18n(),
              ),
            ),
            SizedBox(height: 10.sp),
            SizedBox(
              width: 140.sp,
              child: BaseTextFormField(
                controller: ref.read(createTransactionsDataProvider.notifier).valueController,
                inputFormatter: CommaToDotFormatter(),
                enabled: true,
                keyBoardType: const TextInputType.numberWithOptions(decimal: true),
                focusNode: ref.read(createTransactionsDataProvider.notifier).valueFocusNode,
                suffix: Padding(
                  padding: EdgeInsets.zero,
                  child: FilledButton(
                      onPressed: ref.watch(createTransactionsDataProvider).selectedUser != null &&
                              ref.watch(createTransactionsDataProvider.notifier).valueController.value.text.isNotEmpty
                          ? () {
                              ref
                                  .read(createTransactionsDataProvider.notifier)
                                  .addTransaction()
                                  .then((r) => ref.read(createTransactionsDataProvider.notifier).usersFocusNode.requestFocus());
                            }
                          : null,
                      child: const Icon(
                        Icons.add,
                      )),
                ),
                textInputAction: TextInputAction.go,
                onFieldSubmitted: ref.watch(createTransactionsDataProvider).selectedUser != null &&
                        ref.watch(createTransactionsDataProvider.notifier).valueController.value.text.isNotEmpty
                    ? (text) => ref
                        .read(createTransactionsDataProvider.notifier)
                        .addTransaction()
                        .then((r) => ref.read(createTransactionsDataProvider.notifier).usersFocusNode.requestFocus())
                    : null,
                labelText: Utils.getTransactionTypeText(ref.watch(createTransactionsDataProvider).transactionType),
              ),
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
