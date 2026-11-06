import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart';

/// A small line saying the plan is the copy on the device and how many marks wait to be sent. Nothing while online.
class ReadingPlanOfflineHint extends ConsumerWidget {
  const ReadingPlanOfflineHint({super.key, this.padding});

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readingPlanProvider);
    if (!state.offline || state.plan == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final text = state.unsent > 0
        ? "reading_plan_offline_unsent".i18n([state.unsent.toString()])
        : "reading_plan_offline".i18n();
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.sp, vertical: 6.sp),
      child: Row(
        children: [
          Icon(Icons.cloud_off, size: 16.sp, color: theme.hintColor),
          SizedBox(width: 6.sp),
          Expanded(
            child: Text(text, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          ),
        ],
      ),
    );
  }
}
