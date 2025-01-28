import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/providers/theme_provider.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/work_drop_down_dearch_form_field.dart';
import 'package:work_hu/features/create_activity/provider/create_activity_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

class ActivityDetails extends ConsumerWidget {
  const ActivityDetails({super.key});

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 4.sp),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: ref.watch(createActivityDataProvider.notifier).dateController,
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: "create_activity_activity_date".i18n(),
                  suffixIcon: IconButton(
                    onPressed: () => _selectDate(context, ref),
                    icon: const Icon(Icons.calendar_month),
                  )),
            ),
            SizedBox(height: 5.sp),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: ref.watch(createActivityDataProvider.notifier).descriptionController,
              decoration: InputDecoration(labelText: "create_activity_description".i18n()),
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'create_activity_description_error'.i18n();
                }
                return null;
              },
              autocorrect: true,
              textInputAction: TextInputAction.next,
              // onSubmitted: (text) => ref.watch(createActivityDataProvider.notifier).updateDescription(text),
            ),
            SizedBox(height: 5.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("create_activity_employer".i18n()),
              ],
            ),
            SizedBox(
              child: WorkDropDownSearchFormField<UserModel>(
                direction: AxisDirection.down,
                enabled: ref.watch(createActivityDataProvider).account == Account.MYSHARE,
                onTap: () {
                  ref.watch(createActivityDataProvider.notifier).employerController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset:
                          ref.watch(createActivityDataProvider.notifier).employerController.value.text.length);
                },
                onSuggestionSelected: (UserModel suggestion) {
                  ref.read(createActivityDataProvider.notifier).updateEmployer(suggestion);
                },
                itemBuilder: (context, data) => Text("${data.getFullName()} (${data.getAge()})"),
                suggestionsCallback: (String pattern) =>
                    ref.read(createActivityDataProvider.notifier).filterUsers(pattern),
                controller: ref.watch(createActivityDataProvider.notifier).employerController,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("create_activity_responsible".i18n()),
              ],
            ),
            WorkDropDownSearchFormField<UserModel>(
              direction: AxisDirection.up,
              onSuggestionSelected: (UserModel suggestion) =>
                  ref.read(createActivityDataProvider.notifier).updateResponsible(suggestion),
              itemBuilder: (context, data) => Text("${data.getFullName()} (${data.getAge()})"),
              suggestionsCallback: (String pattern) =>
                  ref.read(createActivityDataProvider.notifier).filterUsers(pattern),
              controller: ref.watch(createActivityDataProvider.notifier).responsibleController,
              onTap: () => ref.watch(createActivityDataProvider.notifier).responsibleController.selection =
                  TextSelection(
                      baseOffset: 0,
                      extentOffset:
                          ref.watch(createActivityDataProvider.notifier).responsibleController.value.text.length),
            ),
            SizedBox(height: 5.sp),
            ref.watch(createActivityDataProvider).employer != null &&
                    ref.watch(createActivityDataProvider).employer!.myShareID == 0
                ? Padding(
                    padding: EdgeInsets.only(top: 4.sp, bottom: 4.sp),
                    child: DropdownButtonFormField(
                        dropdownColor: ref.watch(themeProvider) == ThemeMode.dark
                            ? AppColors.primary200
                            : AppColors.backgroundColor,
                        alignment: AlignmentDirectional.topStart,
                        borderRadius: BorderRadius.all(Radius.circular(8.sp)),
                        decoration: InputDecoration(labelText: "create_activity_transaction_type".i18n()),
                        value: ref.watch(createActivityDataProvider).transactionType,
                        items: [TransactionType.DUKA_MUNKA_2000, TransactionType.DUKA_MUNKA, TransactionType.POINT]
                            .map((e) => DropdownMenuItem<TransactionType>(
                                  value: e,
                                  child: Text(e.name),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            value != null ? ref.watch(createActivityDataProvider.notifier).updateAccount(value) : null),
                  )
                : const SizedBox(),
            ref.watch(createActivityDataProvider).description.isEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "create_activity_description_error".i18n(),
                        style: const TextStyle(color: AppColors.errorRed),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (date != null && context.mounted) {
      final TimeOfDay? time =
          await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
      if (time != null) {
        var dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        ref.watch(createActivityDataProvider.notifier).dateController.text = dateTime.toString();
      }
    }
  }
}
