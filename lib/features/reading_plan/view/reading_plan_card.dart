import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart';

/// The reading challenge on the Status page: the user's progress, this week's goal and the pace needed to finish.
/// Not shown when there is no plan (or it could not be loaded); a tap opens the psalms.
class ReadingPlanCard extends ConsumerWidget {
  const ReadingPlanCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(readingPlanProvider).plan;
    if (plan == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final now = DateTime.now();
    final week = plan.weekOn(now);
    final done = plan.remaining == 0;
    final String hint;
    if (done) {
      hint = "reading_plan_done".i18n();
    } else if (!plan.open) {
      hint = (now.isBefore(plan.startDate) ? "reading_plan_not_started" : "reading_plan_ended").i18n();
    } else {
      final perDay = (plan.remaining / plan.daysLeft(now).clamp(1, 1000)).ceil();
      hint = "reading_plan_pace".i18n([plan.remaining.toString(), perDay.toString()]);
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: BaseContainer(
        padding: EdgeInsets.all(16.sp),
        onTap: () => context.push('/psalms'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.menu_book_outlined, color: theme.colorScheme.primary),
                SizedBox(width: 8.sp),
                Expanded(
                  child: Text(plan.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
                Icon(Icons.chevron_right, color: theme.hintColor),
              ],
            ),
            SizedBox(height: 12.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("reading_plan_progress".i18n([plan.readCount.toString(), plan.itemCount.toString()])),
                Text("${(plan.progress * 100).round()}%", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 6.sp),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.sp),
              child: LinearProgressIndicator(value: plan.progress, minHeight: 10.sp),
            ),
            SizedBox(height: 10.sp),
            if (week != null)
              Text(
                "reading_plan_week_goal".i18n([
                  week.weekNumber.toString(),
                  plan.readIn(week).toString(),
                  week.size.toString(),
                ]),
                style: theme.textTheme.bodyMedium,
              ),
            SizedBox(height: 2.sp),
            Text(hint, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          ],
        ),
      ),
    );
  }
}
