import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/widgets/list_card.dart';
import 'package:work_hu/features/create_activity/provider/create_activity_provider.dart';
import 'package:work_hu/features/create_activity/widgets/activity_details.dart';

class CollapsableDetailsLayout extends ConsumerWidget {
  const CollapsableDetailsLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListCard(
        isLast: true,
        index: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionPanelList(
            expansionCallback: (index, isOpen) =>
                ref.watch(createActivityDataProvider.notifier).updateCollapsed(isOpen),
            elevation: 0,
            children: [
              ExpansionPanel(
                canTapOnHeader: true,
                  isExpanded: ref.watch(createActivityDataProvider).isCollapsed,
                  headerBuilder: (context, isOpen) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text("Activity details", style: TextStyle(fontSize: 15.sp))],
                    );
                  },
                  body: const Column(
                    children: [ActivityDetails()],
                  ))
            ],
          ),
        ));
  }
}
