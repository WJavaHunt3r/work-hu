import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';

class ActivityDetails extends StatelessWidget {
  const ActivityDetails({super.key, required this.activity, required this.hourCount});

  final ActivityModel activity;
  final num hourCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseTextFormField(
            enabled: false,
            initialValue: activity.activityDateTime.toString(),
            labelText: "activity_activity_date".i18n(),
            onChanged: (text) => ()),
        BaseTextFormField(
            enabled: false,
            initialValue: activity.description,
            labelText: "activity_description".i18n(),
            onChanged: (text) => ()),
        BaseTextFormField(
            enabled: false,
            initialValue: activity.responsible.getFullName(),
            labelText: "activity_responsible".i18n(),
            onChanged: (text) => ()),
        BaseTextFormField(
            enabled: false,
            initialValue: activity.employer.getFullName(),
            labelText: "activity_employer".i18n(),
            onChanged: (text) => ()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("activity_registered_in_app".i18n()),
                Checkbox(value: activity.registeredInApp, onChanged: null),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("activity_registered_in_myshare".i18n()),
                Checkbox(value: activity.registeredInMyShare, onChanged: null),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("activity_paid_activity".i18n()), Text(activity.transactionType.name)],
        ),
        Padding(
          padding: EdgeInsets.all(8.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "activity_sum_hours".i18n(),
                style: (TextStyle(fontSize: 15.sp)),
              ),
              Text(hourCount.toString(), style: (TextStyle(fontSize: 15.sp)))
            ],
          ),
        )
      ],
    );
  }
}
