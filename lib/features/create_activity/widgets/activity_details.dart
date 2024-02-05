import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/work_drop_down_dearch_form_field.dart';
import 'package:work_hu/features/create_activity/provider/create_activity_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

class ActivityDetails extends ConsumerWidget {
  const ActivityDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 4.sp),
      child: Column(
        children: [
          TextField(
            controller: ref.watch(createActivityDataProvider.notifier).dateController,
            decoration: InputDecoration(
                labelText: "Activity Date",
                suffixIcon: IconButton(
                  onPressed: () => _selectDate(context, ref),
                  icon: const Icon(Icons.calendar_month),
                )),
          ),
          SizedBox(height: 5.sp),
          TextField(
            controller: ref.watch(createActivityDataProvider.notifier).descriptionController,
            decoration: InputDecoration(
                labelText: "Description",
                // suffixIcon: IconButton(
                //   onPressed: () => ref.watch(createActivityDataProvider.notifier).updateDescription(
                //       ref.watch(createActivityDataProvider.notifier).descriptionController.value.text),
                //   icon: const Icon(Icons.done),
                ),
            autofillHints: ["Terem takarítás", "Pipetta"],
            autocorrect: true,
            textInputAction: TextInputAction.next,
            // onSubmitted: (text) => ref.watch(createActivityDataProvider.notifier).updateDescription(text),
          ),
          SizedBox(height: 5.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Paid"),
              Switch(
                  activeColor: AppColors.primary,
                  inactiveTrackColor: AppColors.primary100,
                  value: ref.watch(createActivityDataProvider).account == Account.MYSHARE,
                  onChanged: (value) => ref.watch(createActivityDataProvider.notifier).updateAccount(value)),
            ],
          ),
          SizedBox(height: 5.sp),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Employer"),
            ],
          ),
          WorkDropDownSearchFormField<UserModel>(
            enabled: ref.watch(createActivityDataProvider).account == Account.MYSHARE,
            onSuggestionSelected: (UserModel suggestion) =>
                ref.read(createActivityDataProvider.notifier).updateEmployer(suggestion),
            itemBuilder: (context, data) => Text("${data.getFullName()} (${data.getAge()})"),
            suggestionsCallback: (String pattern) => ref.read(createActivityDataProvider.notifier).filterUsers(pattern),
            controller: ref.watch(createActivityDataProvider.notifier).employerController,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Responsible"),
            ],
          ),
          WorkDropDownSearchFormField<UserModel>(
            onSuggestionSelected: (UserModel suggestion) =>
                ref.read(createActivityDataProvider.notifier).updateResponsible(suggestion),
            itemBuilder: (context, data) => Text("${data.getFullName()} (${data.getAge()})"),
            suggestionsCallback: (String pattern) => ref.read(createActivityDataProvider.notifier).filterUsers(pattern),
            controller: ref.watch(createActivityDataProvider.notifier).responsibleController,
          )
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then((date) async {
      final TimeOfDay? time =
          await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
      if (date != null && time != null) {
        var dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        ref.watch(createActivityDataProvider.notifier).dateController.text = dateTime.toString();
      }
    });
  }
}
