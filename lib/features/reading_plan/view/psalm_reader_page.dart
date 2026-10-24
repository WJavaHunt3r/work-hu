import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/reading_plan/data/model/bible_translation.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart';

/// One psalm in a bundled translation (the user's pick, else by app language), with previous / next and the "read it" button.
class PsalmReaderPage extends ConsumerWidget {
  const PsalmReaderPage({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final plan = ref.watch(readingPlanProvider).plan;
    final translation = ref.watch(activeTranslationProvider);
    final text = ref.watch(psalmTextProvider(translation.id));
    final last = plan?.itemCount ?? 150;
    final done = plan?.myItems.contains(number) ?? false;
    final canMark = plan != null && plan.open;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "reading_plan_psalm_title".i18n([number.toString()]),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: "reading_plan_translation_pick".i18n(),
            initialValue: translation.id,
            onSelected: (id) => ref.read(bibleChoiceProvider.notifier).select(id),
            itemBuilder: (context) => [
              for (final t in bibleTranslations) PopupMenuItem(value: t.id, child: Text(t.name)),
            ],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.sp),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.translate),
                  SizedBox(width: 4.sp),
                  Text(translation.shortName, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: text.when(
              loading: () => const Center(child: CircularProgressIndicator.adaptive()),
              error: (_, _) => Center(child: Text("api_unknown_error".i18n())),
              data: (psalms) {
                final verses = psalms[number];
                if (verses == null) return Center(child: Text("reading_plan_missing_text".i18n()));
                return ListView(
                  padding: EdgeInsets.fromLTRB(16.sp, 8.sp, 16.sp, 16.sp),
                  children: [
                    Text(translation.name, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                    SizedBox(height: 12.sp),
                    for (final v in verses)
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.sp),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 28.sp,
                              child: Padding(
                                padding: EdgeInsets.only(top: 4.sp),
                                child: Text(
                                  "${v.number}",
                                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
                                ),
                              ),
                            ),
                            Expanded(child: Text(v.text, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6))),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.sp, 8.sp, 16.sp, 8.sp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: done
                        ? FilledButton.tonalIcon(
                            onPressed: canMark
                                ? () => ref.read(readingPlanProvider.notifier).setRead(number, read: false)
                                : null,
                            icon: const Icon(Icons.check_circle),
                            label: Text("reading_plan_undo".i18n()),
                          )
                        : FilledButton.icon(
                            onPressed: canMark
                                ? () => ref.read(readingPlanProvider.notifier).setRead(number, read: true)
                                : null,
                            icon: const Icon(Icons.check),
                            label: Text("reading_plan_mark".i18n()),
                          ),
                  ),
                  if (plan != null && !plan.open)
                    Padding(
                      padding: EdgeInsets.only(top: 4.sp),
                      child: Text(
                        "reading_plan_closed_hint".i18n(),
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                      ),
                    ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: number > 1 ? () => context.pushReplacement('/psalms/${number - 1}') : null,
                        icon: const Icon(Icons.chevron_left),
                        label: Text("reading_plan_previous".i18n()),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: number < last ? () => context.pushReplacement('/psalms/${number + 1}') : null,
                        icon: const Icon(Icons.chevron_right),
                        iconAlignment: IconAlignment.end,
                        label: Text("reading_plan_next".i18n()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
