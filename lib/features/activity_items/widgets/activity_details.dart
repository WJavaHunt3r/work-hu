import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activities/providers/avtivity_provider.dart';
import 'package:work_hu/features/activity_items/provider/activity_items_provider.dart';
import 'package:work_hu/features/utils.dart';

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
            labelText: "Activity Date",
            onChanged: (text) => ()),
        BaseTextFormField(
            enabled: false, initialValue: activity.description, labelText: "Description", onChanged: (text) => ()),
        BaseTextFormField(
            enabled: false,
            initialValue: activity.responsible.getFullName(),
            labelText: "Responsible",
            onChanged: (text) => ()),
        BaseTextFormField(
            enabled: false,
            initialValue: activity.employer.getFullName(),
            labelText: "Employer",
            onChanged: (text) => ()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Action"),
                Checkbox(value: activity.registeredInApp, onChanged: null),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("MyShare"),
                Checkbox(value: activity.registeredInMyShare, onChanged: null),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Paid"),
                Checkbox(value: activity.account == Account.MYSHARE, onChanged: null,),
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sum Hours:",
                style: (TextStyle(fontSize: 15.sp)),
              ),
              Text(Utils.creditFormat.format(hourCount), style: (TextStyle(fontSize: 15.sp)))
            ],
          ),
        )
      ],
    );
  }
}
