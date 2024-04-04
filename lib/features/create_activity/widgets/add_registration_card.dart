import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/work_drop_down_dearch_form_field.dart';
import 'package:work_hu/features/create_activity/provider/create_activity_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/profile/widgets/info_card.dart';
import 'package:work_hu/features/utils.dart';

class AddRegistrationCard extends ConsumerWidget {
  const AddRegistrationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isError = ref.watch(createActivityDataProvider).modelState == ModelState.error;
    return InfoCard(
        padding: 4.sp,
        height: isError ? 150.sp : 110.sp,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WorkDropDownSearchFormField<UserModel>(
              direction: AxisDirection.up,
              onTap: () => ref.watch(createActivityDataProvider.notifier).updateCollapsed(false),
              controller: ref.read(createActivityDataProvider.notifier).userController,
              onSuggestionSelected: (UserModel suggestion) =>
                  ref.read(createActivityDataProvider.notifier).updateSelectedUser(suggestion),
              itemBuilder: (context, data) => Text("${data.getFullName()} (${data.getAge()})"),
              suggestionsCallback: (String pattern) =>
                  ref.read(createActivityDataProvider.notifier).filterUsers(pattern),
            ),
            SizedBox(height: 10.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 150.sp,
                    child: TextField(
                      controller: ref.read(createActivityDataProvider.notifier).hoursController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      focusNode: ref.read(createActivityDataProvider.notifier).valueFocusNode,
                      textInputAction: TextInputAction.go,
                      onSubmitted: ref.watch(createActivityDataProvider).selectedUser != null &&
                              ref.watch(createActivityDataProvider.notifier).hoursController.value.text.isNotEmpty
                          ? (text) => ref.read(createActivityDataProvider.notifier).addRegistration()
                          : null,
                      decoration: InputDecoration(labelText: Utils.getTransactionTypeText(TransactionType.HOURS)),
                    )),
                TextButton(
                    onPressed: ref.watch(createActivityDataProvider).selectedUser != null &&
                            ref.watch(createActivityDataProvider.notifier).hoursController.value.text.isNotEmpty
                        ? () => ref.read(createActivityDataProvider.notifier).addRegistration()
                        : null,
                    style: ButtonStyle(
                      side: WidgetStateBorderSide.resolveWith(
                        (states) {
                          if (states.contains(WidgetState.disabled)) {
                            return BorderSide(color: Colors.grey.shade300, width: 2.sp);
                          }
                          return BorderSide(color: AppColors.primary, width: 2.sp);
                        },
                      ),
                      backgroundColor: WidgetStateColor.resolveWith((states) {
                        if (states.contains(WidgetState.disabled)) {
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
                      ref.watch(createActivityDataProvider).errorMessage,
                      style: const TextStyle(color: AppColors.errorRed),
                    ),
                  )
                : const SizedBox(),
          ],
        ));
  }
}
