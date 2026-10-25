import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/platform/adaptive.dart';
import 'package:work_hu/features/bible/view/bible_annotation_widgets.dart' show showNoteEditor;
import 'package:work_hu/features/reading_plan/data/model/bible_translation.dart';
import 'package:work_hu/features/reading_plan/data/model/public_note.dart';
import 'package:work_hu/features/reading_plan/providers/public_notes_provider.dart';

/// "1. vers", "1–3. vers"; with the translation's short name when it numbers the psalm differently from the one read.
String publicNoteVerses(PublicNote note, String readNumbering) {
  final range = note.verseStart == note.verseEnd ? "${note.verseStart}" : "${note.verseStart}–${note.verseEnd}";
  final verses = "reading_plan_public_verses".i18n([range]);
  return note.numbering == readNumbering ? verses : "$verses (${translationById(note.translation).shortName})";
}

/// Asks the reader why they report a note; null when cancelled, "" for no reason.
Future<String?> askReportReason(BuildContext context) {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (context) => AdaptiveAlertDialog(
      title: Text("reading_plan_public_report_title".i18n()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("reading_plan_public_report_text".i18n()),
          SizedBox(height: 8.sp),
          Material(
            type: MaterialType.transparency,
            child: TextField(
              controller: controller,
              maxLength: 500,
              decoration: InputDecoration(hintText: "reading_plan_public_report_hint".i18n()),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("bible_cancel".i18n())),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          child: Text("reading_plan_public_report".i18n()),
        ),
      ],
    ),
  );
}

Future<bool> _confirmDelete(BuildContext context) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AdaptiveAlertDialog(
        content: Text("reading_plan_public_delete_question".i18n()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("bible_cancel".i18n())),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text("bible_note_delete".i18n())),
        ],
      ),
    ) ??
    false;

/// The public notes of a psalm, below its text: author, verses and text, with a menu to edit / delete your own,
/// report others' and (managers) hide or delete any.
class PublicNotesSection extends ConsumerWidget {
  const PublicNotesSection({
    super.key,
    required this.planId,
    required this.item,
    required this.numbering,
    required this.open,
  });

  final num planId;
  final int item;

  /// The numbering label of the psalm in the translation being read.
  final String numbering;

  /// The plan is open: notes can be edited.
  final bool open;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notes = ref.watch(publicNotesProvider((planId: planId, item: item)));
    final list = notes.value ?? const <PublicNote>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(height: 32.sp),
        Row(
          children: [
            Icon(Icons.forum_outlined, size: 20.sp, color: theme.colorScheme.primary),
            SizedBox(width: 8.sp),
            Text(
              "reading_plan_public_title".i18n([list.length.toString()]),
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 8.sp),
        if (notes.isLoading && !notes.hasValue)
          const Center(child: CircularProgressIndicator.adaptive())
        else if (notes.hasError && !notes.hasValue)
          Text("api_unknown_error".i18n(), style: TextStyle(color: theme.hintColor))
        else if (list.isEmpty)
          Text("reading_plan_public_empty".i18n(), style: TextStyle(color: theme.hintColor))
        else
          for (final note in list)
            _PublicNoteCard(planId: planId, item: item, note: note, numbering: numbering, open: open),
      ],
    );
  }
}

enum _Action { edit, delete, report, hide, show }

class _PublicNoteCard extends ConsumerWidget {
  const _PublicNoteCard({
    required this.planId,
    required this.item,
    required this.note,
    required this.numbering,
    required this.open,
  });

  final num planId;
  final int item;
  final PublicNote note;
  final String numbering;
  final bool open;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final manage = ref.watch(publicNotesAccessProvider).manage;
    final notifier = ref.read(publicNotesProvider((planId: planId, item: item)).notifier);
    final actions = [
      if (note.mine && open) _Action.edit,
      if (note.mine || manage) _Action.delete,
      if (!note.mine && !note.reportedByMe) _Action.report,
      if (manage && !note.hidden) _Action.hide,
      if (manage && note.hidden) _Action.show,
    ];

    Future<void> run(_Action action) async {
      switch (action) {
        case _Action.edit:
          final text = await showNoteEditor(
            context,
            title: "reading_plan_public_note".i18n(),
            notice: "reading_plan_public_notice".i18n(),
            initial: note.text,
            maxLength: 2000,
          );
          if (text != null) await notifier.edit(note, text);
        case _Action.delete:
          if (await _confirmDelete(context)) await notifier.delete(note);
        case _Action.report:
          final reason = await askReportReason(context);
          if (reason != null && await notifier.report(note, reason.isEmpty ? null : reason) && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("reading_plan_public_reported".i18n())));
          }
        case _Action.hide:
          await notifier.setHidden(note, true);
        case _Action.show:
          await notifier.setHidden(note, false);
      }
    }

    String label(_Action a) => switch (a) {
      _Action.edit => "bible_note_edit".i18n(),
      _Action.delete => "bible_note_delete".i18n(),
      _Action.report => "reading_plan_public_report".i18n(),
      _Action.hide => "reading_plan_public_hide".i18n(),
      _Action.show => "reading_plan_public_show".i18n(),
    };

    return Card(
      margin: EdgeInsets.only(bottom: 8.sp),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.sp, 8.sp, 0, 10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: note.author,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: "  ·  ${publicNoteVerses(note, numbering)}"),
                      ],
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                if (actions.isNotEmpty)
                  PopupMenuButton<_Action>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: run,
                    itemBuilder: (context) => [for (final a in actions) PopupMenuItem(value: a, child: Text(label(a)))],
                  )
                else
                  SizedBox(height: 40.sp),
              ],
            ),
            // the managers' and the author's badges on a line of their own, so the header fits a narrow phone
            if (note.hidden || (manage && (note.reportCount ?? 0) > 0))
              Padding(
                padding: EdgeInsets.only(bottom: 4.sp),
                child: Wrap(
                  spacing: 8.sp,
                  children: [
                    if (note.hidden)
                      Text(
                        "reading_plan_public_hidden".i18n(),
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    if (manage && (note.reportCount ?? 0) > 0)
                      Text(
                        "reading_plan_public_report_count".i18n([note.reportCount.toString()]),
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                      ),
                  ],
                ),
              ),
            Padding(
              padding: EdgeInsets.only(right: 12.sp),
              child: Text(note.text, style: theme.textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}
