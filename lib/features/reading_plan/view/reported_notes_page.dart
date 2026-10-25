import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/features/reading_plan/data/model/public_note.dart';
import 'package:work_hu/features/reading_plan/providers/public_notes_provider.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart';

/// Managers (READING_PLAN_MANAGE, `/admin/readingPlan/reported`): the reported shared notes of the current plan with
/// the reasons given, to hide, show again or delete; "open" shows the psalm with all its notes.
class ReportedNotesPage extends ConsumerWidget {
  const ReportedNotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(readingPlanProvider).plan;
    return Scaffold(
      appBar: AppBar(
        title: Text("reading_plan_reported_title".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: plan == null
          ? Center(child: Text("reading_plan_none".i18n()))
          : RefreshIndicator.adaptive(
              onRefresh: () async => ref.refresh(reportedNotesProvider(plan.id).future),
              child: ref
                  .watch(reportedNotesProvider(plan.id))
                  .when(
                    loading: () => const Center(child: CircularProgressIndicator.adaptive()),
                    error: (_, _) => Center(child: Text("api_unknown_error".i18n())),
                    data: (list) => list.isEmpty
                        ? ListView(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(32.sp),
                                child: Text("reading_plan_reported_none".i18n(), textAlign: TextAlign.center),
                              ),
                            ],
                          )
                        : ListView(
                            padding: EdgeInsets.all(12.sp),
                            children: [for (final r in list) _ReportedCard(planId: plan.id, reported: r)],
                          ),
                  ),
            ),
    );
  }
}

class _ReportedCard extends ConsumerWidget {
  const _ReportedCard({required this.planId, required this.reported});

  final num planId;
  final ReportedNote reported;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final note = reported.note;
    final api = ref.read(publicNoteApiProvider);
    // Straight to the API: the psalm's own notes provider isn't alive on this page
    Future<void> act(Future<void> Function() call) async {
      try {
        await guardApi(call);
      } on ApiException catch (e) {
        showApiError(e.message);
        return;
      } catch (_) {
        showApiError("api_unknown_error".i18n());
        return;
      }
      ref.invalidate(reportedNotesProvider(planId));
      ref.invalidate(publicNoteCountsProvider(planId));
      ref.invalidate(publicNotesProvider((planId: planId, item: note.item)));
    }

    final range = note.verseStart == note.verseEnd ? "${note.verseStart}" : "${note.verseStart}–${note.verseEnd}";
    return Card(
      margin: EdgeInsets.only(bottom: 10.sp),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${"reading_plan_psalm_title".i18n([note.item.toString()])}, ${"reading_plan_public_verses".i18n([range])}  ·  ${note.author}",
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.sp),
            Text(note.text),
            SizedBox(height: 8.sp),
            Text(
              "reading_plan_public_report_count".i18n([reported.reasons.length.toString()]),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
            ),
            for (final reason in reported.reasons)
              Text(
                "• ${reason ?? "reading_plan_reported_no_reason".i18n()}",
                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              ),
            if (note.hidden)
              Padding(
                padding: EdgeInsets.only(top: 4.sp),
                child: Text("reading_plan_public_hidden".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            Wrap(
              spacing: 4.sp,
              children: [
                TextButton(
                  onPressed: () => context.push('/psalms/${note.item}'),
                  child: Text("reading_plan_reported_open".i18n()),
                ),
                TextButton(
                  onPressed: () => act(() => api.setHidden(planId, note.id, !note.hidden)),
                  child: Text((note.hidden ? "reading_plan_public_show" : "reading_plan_public_hide").i18n()),
                ),
                TextButton(
                  onPressed: () => act(() => api.delete(planId, note.id)),
                  style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
                  child: Text("bible_note_delete".i18n()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
