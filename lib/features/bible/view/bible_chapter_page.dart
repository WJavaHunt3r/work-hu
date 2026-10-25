import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/bible/data/model/bible_annotation.dart';
import 'package:work_hu/features/bible/data/model/bible_model.dart';
import 'package:work_hu/features/bible/providers/bible_annotations_provider.dart';
import 'package:work_hu/features/bible/providers/bible_provider.dart';
import 'package:work_hu/features/bible/view/bible_annotation_widgets.dart';
import 'package:work_hu/features/bible/view/bible_page.dart';
import 'package:work_hu/features/bible/view/bible_widgets.dart';
import 'package:work_hu/features/reading_plan/data/model/bible_translation.dart' show translationById;

/// One chapter (`/bible/:book/:chapter`, book = OSIS code such as "John") in the active translation, with previous /
/// next across books (also by swiping). Opening it makes it the "Continue" chapter. Tapping verses selects them and
/// shows [BibleSelectionBar] (highlight, note, bookmark, copy) instead of previous / next; highlights colour the verse,
/// notes and bookmarks show as small icons. [focusVerse]..[focusEnd] (`?verse=16` or `?verse=16-18`, from the list of
/// notes or a shared link) is scrolled to and
/// lit up for a moment.
class BibleChapterPage extends ConsumerStatefulWidget {
  const BibleChapterPage({super.key, required this.osis, required this.chapter, this.focusVerse, this.focusEnd});

  final String osis;
  final int chapter;
  final int? focusVerse;
  final int? focusEnd;

  @override
  ConsumerState<BibleChapterPage> createState() => _BibleChapterPageState();
}

class _BibleChapterPageState extends ConsumerState<BibleChapterPage> {
  final _selected = <int>{};
  final _keys = <int, GlobalKey>{};
  Set<int> _flash = const {};
  Timer? _flashTimer;
  bool _focused = false;

  String get osis => widget.osis;
  int get chapter => widget.chapter;

  GlobalKey _keyOf(int verse) => _keys.putIfAbsent(verse, GlobalKey.new);

  void _toggle(int verse) => setState(() => _selected.contains(verse) ? _selected.remove(verse) : _selected.add(verse));

  /// Scrolls to [BibleChapterPage.focusVerse] once the text is there, and lights it up for two seconds.
  void _focusOnce() {
    final verse = widget.focusVerse;
    if (_focused || verse == null) return;
    _focused = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = _keys[verse]?.currentContext;
      if (target == null || !mounted) return;
      Scrollable.ensureVisible(target, alignment: 0.2, duration: const Duration(milliseconds: 300));
      setState(() => _flash = {for (var v = verse; v <= (widget.focusEnd ?? verse); v++) v});
      _flashTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) setState(() => _flash = const {});
      });
    });
  }

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = ref.watch(bibleTranslationIdProvider);
    final secondId = ref.watch(bibleParallelIdProvider);
    final book = ref.watch(bibleTextProvider(id).select((s) => s.bible?.book(osis)));
    final annotations = ref.watch(bibleAnnotationsProvider);
    final position = BiblePosition(osis, chapter);
    return Scaffold(
      appBar: AppBar(
        // "Róm 4 ▾": the Bible page's book grid, then chapter and verse; back to the Bible page when it is open (also
        // past the notes list), else the Bible page takes the reader's place (opened from Home's "Continue")
        title: InkWell(
          borderRadius: BorderRadius.circular(8.sp),
          onTap: () {
            // The book grid, then chapter and verse (the book being read is highlighted)
            ref.read(bibleSelectedBookProvider.notifier).state = null;
            ref.read(bibleSelectedChapterProvider.notifier).state = null;
            BiblePage.showFrom(context);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  book == null ? "bible_title".i18n() : "${book.abbreviation} $chapter",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        actions: const [BibleParallelButton(), BibleTranslationButton()],
      ),
      body: BibleTextView(
        builder: (context, bible) {
          final book = bible.book(osis);
          final verses = book?.chapter(chapter);
          if (book == null || verses == null) return Center(child: Text("bible_not_found".i18n()));
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => ref
                .read(biblePositionProvider.notifier)
                .set(BiblePosition(osis, chapter, label: "${book.name} $chapter")),
          );
          _focusOnce();
          final place = BiblePlace(
            translation: id,
            numbering: book.numberingOf(chapter),
            book: osis,
            chapter: chapter,
            lastVerse: verses.last.number,
          );
          final view = _VerseView(
            marks: verseMarks(annotations, osis, chapter, place.numbering, lastVerse: place.lastVerse),
            selected: _selected,
            flash: _flash,
            keyOf: _keyOf,
            onTap: _toggle,
            onNotes: (notes) => showNotesSheet(context, ref, book.name, notes),
          );
          final previous = position.previous(bible);
          final next = position.next(bible);
          return Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    final v = details.primaryVelocity ?? 0;
                    if (v < -300 && next != null) context.pushReplacement(next.route);
                    if (v > 300 && previous != null) context.pushReplacement(previous.route);
                  },
                  child: secondId == null
                      ? _Verses(bible: bible, verses: verses, view: view)
                      : _ParallelVerses(
                          bible: bible,
                          verses: verses,
                          position: position,
                          secondId: secondId,
                          view: view,
                          annotations: annotations,
                        ),
                ),
              ),
              if (_selected.isNotEmpty)
                BibleSelectionBar(
                  place: place,
                  bookName: book.name,
                  bookAbbreviation: book.abbreviation,
                  translationName: bible.name,
                  verses: verses,
                  selected: _selected,
                  onDone: () => setState(_selected.clear),
                )
              else
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextButton.icon(
                            onPressed: previous == null ? null : () => context.pushReplacement(previous.route),
                            icon: const Icon(Icons.chevron_left),
                            label: Text(
                              _label(bible, previous) ?? "reading_plan_previous".i18n(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Flexible(
                          child: TextButton.icon(
                            onPressed: next == null ? null : () => context.pushReplacement(next.route),
                            icon: const Icon(Icons.chevron_right),
                            iconAlignment: IconAlignment.end,
                            label: Text(
                              _label(bible, next) ?? "reading_plan_next".i18n(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// "János 4", or null at the ends of the Bible.
  static String? _label(Bible bible, BiblePosition? p) => p == null ? null : "${bible.book(p.osis)!.name} ${p.chapter}";
}

/// What the verse lists need besides the text: the marks of the active translation's verses, the selection, the
/// verse lit up after opening from the list of notes, and what a tap does.
class _VerseView {
  const _VerseView({
    required this.marks,
    required this.selected,
    required this.flash,
    required this.keyOf,
    required this.onTap,
    required this.onNotes,
  });

  final Map<int, VerseMarks> marks;
  final Set<int> selected;
  final Set<int> flash;
  final GlobalKey Function(int verse) keyOf;
  final void Function(int verse) onTap;
  final void Function(List<BibleAnnotation> notes) onNotes;
}

/// One verse: its number (with a bookmark below it), the text on its highlight colour, a note icon; a frame while
/// selected.
class BibleVerseTile extends StatelessWidget {
  const BibleVerseTile({
    super.key,
    required this.verse,
    required this.marks,
    required this.textStyle,
    required this.numberWidth,
    this.selected = false,
    this.flash = false,
    this.onTap,
    this.onNotes,
  });

  final Verse verse;
  final VerseMarks? marks;
  final TextStyle? textStyle;
  final double numberWidth;
  final bool selected;
  final bool flash;
  final VoidCallback? onTap;
  final void Function(List<BibleAnnotation> notes)? onNotes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = marks?.color;
    final notes = marks?.notes ?? const <BibleAnnotation>[];
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.sp),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 4.sp),
        decoration: BoxDecoration(
          color: color != null
              ? highlightBackground(context, color)
              : flash
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : null,
          borderRadius: BorderRadius.circular(6.sp),
          border: Border.all(color: selected ? theme.colorScheme.primary : Colors.transparent, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: numberWidth,
              child: Padding(
                padding: EdgeInsets.only(top: 3.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${verse.number}",
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
                    ),
                    if (marks?.bookmark ?? false)
                      Icon(
                        Icons.bookmark,
                        size: 14.sp,
                        color: theme.colorScheme.primary,
                        semanticLabel: "bible_bookmark".i18n(),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(verse.text, style: textStyle),
                  // A mark from a translation that numbers this chapter differently, with no rule to move it
                  if (marks?.otherNumbering.isNotEmpty ?? false)
                    Text(
                      "bible_other_numbering".i18n([
                        marks!.otherNumbering.map((id) => translationById(id).shortName).join(", "),
                      ]),
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor, fontStyle: FontStyle.italic),
                    ),
                ],
              ),
            ),
            if (notes.isNotEmpty)
              InkResponse(
                radius: 18.sp,
                onTap: onNotes == null ? null : () => onNotes!(notes),
                child: Padding(
                  padding: EdgeInsets.only(left: 4.sp, top: 2.sp),
                  child: Icon(
                    Icons.sticky_note_2_outlined,
                    size: 18.sp,
                    color: theme.colorScheme.primary,
                    semanticLabel: "bible_note".i18n(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The chapter in two translations side by side: one row per verse number, so the columns stay level. A verse one
/// translation lacks leaves its cell empty. Where the two number the chapter differently (the chapters' `numbering`
/// labels differ, e.g. Károli's own numbering against KJV), rows pair by number, not by content; a note says so. Each
/// column shows the annotations made for its own numbering; tapping a row selects the active translation's verse.
class _ParallelVerses extends ConsumerWidget {
  const _ParallelVerses({
    required this.bible,
    required this.verses,
    required this.position,
    required this.secondId,
    required this.view,
    required this.annotations,
  });

  final Bible bible;
  final List<Verse> verses;
  final BiblePosition position;
  final String secondId;
  final _VerseView view;
  final Map<String, BibleAnnotation> annotations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final secondText = ref.watch(bibleTextProvider(secondId));
    final second = secondText.bible;
    final secondBook = second?.book(position.osis);
    final secondVerses = secondBook?.chapter(position.chapter) ?? const <Verse>[];
    final secondInfo = ref.watch(bibleTranslationsProvider).value?.where((t) => t.id == secondId).firstOrNull;

    final left = {for (final v in verses) v.number: v};
    final right = {for (final v in secondVerses) v.number: v};
    final numbers = {...left.keys, ...right.keys}.toList()..sort();
    // labels per chapter from the build: equal labels mean the verse numbers mean the same verses
    final leftNumbering = bible.book(position.osis)!.numberingOf(position.chapter);
    final rightNumbering = secondBook?.numberingOf(position.chapter);
    final numberedDifferently = rightNumbering != null && rightNumbering != leftNumbering;
    final rightMarks = rightNumbering == null
        ? const <int, VerseMarks>{}
        : verseMarks(
            annotations,
            position.osis,
            position.chapter,
            rightNumbering,
            lastVerse: secondVerses.isEmpty ? null : secondVerses.last.number,
          );

    final nameStyle = theme.textTheme.bodySmall?.copyWith(color: theme.hintColor);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(height: 1.5);
    Widget row(Widget a, Widget b) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: a),
        SizedBox(width: 8.sp),
        Expanded(child: b),
      ],
    );

    return ListView(
      padding: EdgeInsets.fromLTRB(8.sp, 8.sp, 8.sp, 16.sp),
      children: [
        row(Text(bible.name, style: nameStyle), Text(second?.name ?? secondInfo?.name ?? secondId, style: nameStyle)),
        if (second == null)
          Padding(
            padding: EdgeInsets.only(top: 8.sp),
            child: row(
              const SizedBox.shrink(),
              secondText.failed
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("bible_download_failed_short".i18n(), style: nameStyle),
                        TextButton.icon(
                          onPressed: () => ref.read(bibleTextProvider(secondId).notifier).retry(),
                          icon: const Icon(Icons.refresh),
                          label: Text("bible_retry".i18n()),
                        ),
                      ],
                    )
                  : const Align(alignment: Alignment.centerLeft, child: CircularProgressIndicator.adaptive()),
            ),
          ),
        if (numberedDifferently)
          Padding(
            padding: EdgeInsets.only(top: 8.sp),
            child: Text("bible_parallel_numbering".i18n(), style: nameStyle?.copyWith(fontStyle: FontStyle.italic)),
          ),
        SizedBox(height: 8.sp),
        for (final n in numbers)
          Padding(
            key: left.containsKey(n) ? view.keyOf(n) : null,
            padding: EdgeInsets.only(bottom: 6.sp),
            child: row(
              left[n] == null
                  ? const SizedBox.shrink()
                  : BibleVerseTile(
                      verse: left[n]!,
                      marks: view.marks[n],
                      textStyle: textStyle,
                      numberWidth: 20.sp,
                      selected: view.selected.contains(n),
                      flash: view.flash.contains(n),
                      onTap: () => view.onTap(n),
                      onNotes: view.onNotes,
                    ),
              right[n] == null
                  ? const SizedBox.shrink()
                  : BibleVerseTile(
                      verse: right[n]!,
                      marks: rightMarks[n],
                      textStyle: textStyle,
                      numberWidth: 20.sp,
                      onTap: left.containsKey(n) ? () => view.onTap(n) : null,
                      onNotes: view.onNotes,
                    ),
            ),
          ),
      ],
    );
  }
}

class _Verses extends StatelessWidget {
  const _Verses({required this.bible, required this.verses, required this.view});

  final Bible bible;
  final List<Verse> verses;
  final _VerseView view;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: EdgeInsets.fromLTRB(12.sp, 8.sp, 12.sp, 16.sp),
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.sp),
          child: Text(bible.name, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
        ),
        SizedBox(height: 8.sp),
        for (final v in verses)
          Padding(
            padding: EdgeInsets.only(bottom: 6.sp),
            child: BibleVerseTile(
              key: view.keyOf(v.number),
              verse: v,
              marks: view.marks[v.number],
              textStyle: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
              numberWidth: 28.sp,
              selected: view.selected.contains(v.number),
              flash: view.flash.contains(v.number),
              onTap: () => view.onTap(v.number),
              onNotes: view.onNotes,
            ),
          ),
      ],
    );
  }
}
