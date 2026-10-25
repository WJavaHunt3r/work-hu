import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/bible/providers/bible_annotations_provider.dart';
import 'package:work_hu/features/bible/view/bible_annotation_widgets.dart';
import 'package:work_hu/features/bible/view/bible_chapter_page.dart' show BibleVerseTile;
import 'package:work_hu/features/reading_plan/data/model/bible_translation.dart';
import 'package:work_hu/features/reading_plan/providers/public_notes_provider.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart';
import 'package:work_hu/features/reading_plan/view/public_notes_section.dart';

/// One psalm in a bundled translation (the user's pick, else by app language), with previous / next and the "read it"
/// button. Tapping verses selects them for the Bible's highlights, notes, bookmarks, copy and link (the same marks as
/// in the Bible reader: book "Ps", numbering from [psalmNumbering]) and, for church members while the plan is open,
/// a public note; the psalm's public notes are listed below its text.
class PsalmReaderPage extends ConsumerStatefulWidget {
  const PsalmReaderPage({super.key, required this.number});

  final int number;

  @override
  ConsumerState<PsalmReaderPage> createState() => _PsalmReaderPageState();
}

class _PsalmReaderPageState extends ConsumerState<PsalmReaderPage> {
  final _selected = <int>{};

  int get number => widget.number;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final plan = ref.watch(readingPlanProvider).plan;
    final translation = ref.watch(activeTranslationProvider);
    final text = ref.watch(psalmTextProvider(translation.id));
    final access = ref.watch(publicNotesAccessProvider);
    final names = psalmsBookName(translation.languageCode);
    final numbering = psalmNumbering(translation.id, number);
    final lastVerse = text.value?[number]?.lastOrNull?.number;
    final place = BiblePlace(
      translation: translation.id,
      numbering: numbering,
      book: 'Ps',
      chapter: number,
      lastVerse: lastVerse,
    );
    final marks = verseMarks(ref.watch(bibleAnnotationsProvider), 'Ps', number, numbering, lastVerse: lastVerse);
    final last = plan?.itemCount ?? 150;
    final done = plan?.myItems.contains(number) ?? false;
    final canMark = plan != null && plan.open;
    final publicNotes = plan != null && access.read;
    final verses = text.value?[number];
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
                  padding: EdgeInsets.fromLTRB(12.sp, 8.sp, 12.sp, 16.sp),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 4.sp),
                      child: Text(translation.name, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                    ),
                    SizedBox(height: 8.sp),
                    for (final v in verses)
                      Padding(
                        padding: EdgeInsets.only(bottom: 6.sp),
                        child: BibleVerseTile(
                          verse: v,
                          marks: marks[v.number],
                          textStyle: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                          numberWidth: 28.sp,
                          selected: _selected.contains(v.number),
                          onTap: () => setState(
                            () => _selected.contains(v.number) ? _selected.remove(v.number) : _selected.add(v.number),
                          ),
                          onNotes: (notes) => showNotesSheet(context, ref, names.name, notes),
                        ),
                      ),
                    if (publicNotes)
                      PublicNotesSection(planId: plan.id, item: number, numbering: numbering, open: plan.open),
                  ],
                );
              },
            ),
          ),
          if (_selected.isNotEmpty && verses != null)
            BibleSelectionBar(
              place: place,
              bookName: names.name,
              bookAbbreviation: names.abbreviation,
              translationName: translation.name,
              verses: verses,
              selected: _selected,
              onDone: () => setState(_selected.clear),
              extraActions: [
                if (publicNotes && plan.open)
                  SelectionAction(
                    icon: Icons.forum_outlined,
                    label: "reading_plan_public_short".i18n(),
                    onTap: () async {
                      final sorted = _selected.toList()..sort();
                      final text = await showNoteEditor(
                        context,
                        title:
                            "${"reading_plan_public_note".i18n()} – ${names.name} ${verseRange(number, sorted.first, sorted.last)}",
                        notice: "reading_plan_public_notice".i18n(),
                        maxLength: 2000,
                      );
                      if (text != null) {
                        await ref
                            .read(publicNotesProvider((planId: plan.id, item: number)).notifier)
                            .create(
                              verseStart: sorted.first,
                              verseEnd: sorted.last,
                              translation: translation.id,
                              numbering: numbering,
                              text: text,
                            );
                      }
                      if (mounted) setState(_selected.clear);
                    },
                  ),
              ],
            )
          else
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
