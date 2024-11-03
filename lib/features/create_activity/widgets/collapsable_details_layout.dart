import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/providers/theme_provider.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/collapsable_panel.dart';
import 'package:work_hu/features/create_activity/provider/create_activity_provider.dart';
import 'package:work_hu/features/create_activity/widgets/activity_details.dart';

class CollapsableDetailsLayout extends ConsumerWidget {
  const CollapsableDetailsLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CollapsablePanel(
        expansionCallback: (index, isOpen) => ref.watch(createActivityDataProvider.notifier).updateCollapsed(isOpen),
        panels: [
          ExpansionPanel(
              backgroundColor: ref.watch(themeProvider) == ThemeMode.dark
                  ? AppColors.secondaryGray
                  : AppColors.white,
              canTapOnHeader: true,
              isExpanded: ref.watch(createActivityDataProvider).isCollapsed,
              headerBuilder: (context, isOpen) {
                return Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Text("create_activity_activity_details".i18n(), style: TextStyle(fontSize: 15.sp))],
                  ),
                );
              },
              body: const Column(
                children: [ActivityDetails()],
              ))
        ]);
  }
}
