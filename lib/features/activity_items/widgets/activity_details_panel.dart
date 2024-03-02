import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/widgets/collapsable_panel.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/activities/providers/avtivity_provider.dart';
import 'package:work_hu/features/activity_items/widgets/activity_details.dart';

class ActivityDetailsPanel extends ConsumerWidget {
  const ActivityDetailsPanel(this.activity, this.hourCount, {super.key});

  final ActivityModel activity;
  final num hourCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CollapsablePanel(
        expansionCallback: (index, isOpen) => ref.watch(activityDataProvider.notifier).updateIsExpanded(isOpen),
        panels: [
          ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: ref.watch(activityDataProvider).isExpanded,
              headerBuilder: (context, isOpen) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text("activity_items_activity_details".i18n(), style: TextStyle(fontSize: 15.sp))],
                );
              },
              body: Column(
                children: [ActivityDetails(activity: activity, hourCount: hourCount)],
              ))
        ]);
  }
}
