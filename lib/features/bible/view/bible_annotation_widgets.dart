import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/platform/adaptive.dart';
import 'package:work_hu/features/bible/data/model/bible_annotation.dart';
import 'package:work_hu/features/bible/data/model/bible_model.dart';
import 'package:work_hu/features/bible/providers/bible_annotations_provider.dart';
import 'package:work_hu/features/utils.dart';

/// What a verse shows of the user's annotations. [otherNumbering]: the translations (ids) whose numbering a mark here
/// follows, because this translation numbers the chapter differently and there is no rule to move it.
class VerseMarks {
  HighlightColor? color;
  final notes = <BibleAnnotation>[];
  bool bookmark = false;
  final otherNumbering = <String>{};
}

/// The marks of each verse of a chapter whose numbering label is [numbering] and whose last verse is [lastVerse]:
/// every mark of the chapter, made in any translation, placed by [shownRange]. A note shows at its first verse.
Map<int, VerseMarks> verseMarks(
  Map<String, BibleAnnotation> all,
  String book,
  int chapter,
  String numbering, {
  int? lastVerse,
}) {
  final marks = <int, VerseMarks>{};
  for (final a in all.values) {
    if (a.book != book || a.chapter != chapter) continue;
    final range = shownRange(a, numbering, lastVerse: lastVerse);
    VerseMarks at(int verse) {
      final m = marks.putIfAbsent(verse, VerseMarks.new);
      if (!range.exact) m.otherNumbering.add(a.translation);
      return m;
    }

    switch (a.type) {
      case BibleAnnotationType.highlight:
        for (var v = range.start; v <= range.end; v++) {
          at(v).color = a.color;
        }
      case BibleAnnotationType.note:
        at(range.start).notes.add(a);
      case BibleAnnotationType.bookmark:
        at(range.start).bookmark = true;
    }
  }
  return marks;
}

/// The background of a highlighted verse, softer in the dark theme.
Color highlightBackground(BuildContext context, HighlightColor color) =>
    color.color.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.35 : 0.6);

/// "3:16" or "3:16-18"
String verseRange(int chapter, int start, int end) => start == end ? "$chapter:$start" : "$chapter:$start-$end";

/// The address that opens [book] [chapter] at verses [start]..[end] in the app (or the web app): the Bible reader,
/// open to every signed-in user.
String verseLink(String book, int chapter, int start, int end) =>
    "${Utils.webAppUrl}/bible/$book/$chapter?verse=${start == end ? "$start" : "$start-$end"}";

/// An action of [BibleSelectionBar]: icon over a short label, so five fit a narrow phone.
class SelectionAction extends StatelessWidget {
  const SelectionAction({super.key, required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8.sp),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              SizedBox(height: 2.sp),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The bar shown instead of previous / next while verses are selected: highlight colours, then note, bookmark, copy,
/// link (and [extraActions], e.g. the reading plan's public note). [verses] is the chapter's text, [bookName] /
/// [bookAbbreviation] the book's names in the translation [translationName].
class BibleSelectionBar extends ConsumerWidget {
  const BibleSelectionBar({
    super.key,
    required this.place,
    required this.bookName,
    required this.bookAbbreviation,
    required this.translationName,
    required this.verses,
    required this.selected,
    required this.onDone,
    this.extraActions = const [],
  });

  final BiblePlace place;
  final String bookName;
  final String bookAbbreviation;
  final String translationName;
  final List<Verse> verses;
  final Set<int> selected;
  final VoidCallback onDone;
  final List<Widget> extraActions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(bibleAnnotationsProvider.notifier);
    final sorted = selected.toList()..sort();
    final first = sorted.first;
    final last = sorted.last;
    final marks = verseMarks(
      ref.watch(bibleAnnotationsProvider),
      place.book,
      place.chapter,
      place.numbering,
      lastVerse: place.lastVerse,
    );
    final bookmarked = marks[first]?.bookmark ?? false;
    final reference = "$bookName ${verseRange(place.chapter, first, last)}";

    Future<void> copy(String text, String done) async {
      await Clipboard.setData(ClipboardData(text: text));
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
      onDone();
    }

    Widget dot(HighlightColor? color) => InkResponse(
      radius: 22.sp,
      onTap: () {
        notifier.setHighlight(place, sorted, color);
        onDone();
      },
      child: Container(
        width: 30.sp,
        height: 30.sp,
        margin: EdgeInsets.symmetric(horizontal: 3.sp),
        decoration: BoxDecoration(
          color: color?.color,
          shape: BoxShape.circle,
          border: Border.all(color: theme.dividerColor),
        ),
        child: color == null ? Icon(Icons.format_color_reset, size: 18.sp, color: theme.hintColor) : null,
      ),
    );

    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.sp, 8.sp, 8.sp, 4.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "$bookAbbreviation ${verseRange(place.chapter, first, last)}",
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(tooltip: "bible_cancel".i18n(), icon: const Icon(Icons.close), onPressed: onDone),
                ],
              ),
              // the colours, then the actions: two rows, so everything fits a narrow phone
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final c in HighlightColor.values) Tooltip(message: c.name, child: dot(c)),
                  Tooltip(message: "bible_highlight_remove".i18n(), child: dot(null)),
                ],
              ),
              SizedBox(height: 4.sp),
              Row(
                children: [
                  SelectionAction(
                    icon: Icons.edit_note,
                    label: "bible_note_add".i18n(),
                    onTap: () async {
                      final text = await showNoteEditor(context, title: reference);
                      if (text != null) notifier.saveNote(place, first, last, text);
                      onDone();
                    },
                  ),
                  SelectionAction(
                    icon: bookmarked ? Icons.bookmark_remove : Icons.bookmark_add_outlined,
                    label: "bible_bookmark".i18n(),
                    onTap: () {
                      notifier.toggleBookmark(place, first);
                      onDone();
                    },
                  ),
                  SelectionAction(
                    icon: Icons.copy,
                    label: "bible_copy".i18n(),
                    onTap: () {
                      final text = [
                        for (final v in verses)
                          if (selected.contains(v.number)) "${v.number} ${v.text}",
                      ].join("\n");
                      copy("$reference\n$text\n($translationName)", "bible_copied".i18n());
                    },
                  ),
                  SelectionAction(
                    icon: Icons.link,
                    label: "bible_link".i18n(),
                    onTap: () => copy(
                      "$reference\n${verseLink(place.book, place.chapter, first, last)}",
                      "bible_link_copied".i18n(),
                    ),
                  ),
                  ...extraActions,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Asks for a note's text (starting with [initial]); null when cancelled. [notice] is shown under the title (e.g. who
/// will see the note), [maxLength] limits the text.
Future<String?> showNoteEditor(
  BuildContext context, {
  required String title,
  String? initial,
  String? notice,
  int maxLength = 5000,
}) {
  final controller = TextEditingController(text: initial);
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => Padding(
      padding: EdgeInsets.fromLTRB(16.sp, 0, 16.sp, MediaQuery.viewInsetsOf(context).bottom + 16.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          if (notice != null) ...[
            SizedBox(height: 4.sp),
            Text(notice, style: TextStyle(color: Theme.of(context).hintColor)),
          ],
          SizedBox(height: 12.sp),
          TextField(
            controller: controller,
            autofocus: true,
            minLines: 3,
            maxLines: 10,
            maxLength: maxLength,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(hintText: "bible_note_hint".i18n(), border: const OutlineInputBorder()),
          ),
          SizedBox(height: 8.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("bible_cancel".i18n())),
              SizedBox(width: 8.sp),
              ListenableBuilder(
                listenable: controller,
                builder: (context, _) => FilledButton(
                  onPressed: controller.text.trim().isEmpty
                      ? null
                      : () => Navigator.pop(context, controller.text.trim()),
                  child: Text("bible_note_save".i18n()),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// The notes on a verse, each with edit and delete. Closes itself when the last one is deleted.
Future<void> showNotesSheet(BuildContext context, WidgetRef ref, String bookName, List<BibleAnnotation> notes) {
  var closing = false;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => Consumer(
      builder: (context, ref, _) {
        final all = ref.watch(bibleAnnotationsProvider);
        final current = [for (final n in notes) ?all[n.id]];
        // The sheet rebuilds while it closes (sync answers, route animations): pop once, and only the sheet itself,
        // or each rebuild would pop another page
        if (current.isEmpty && !closing) {
          closing = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (sheetContext.mounted && (ModalRoute.of(sheetContext)?.isCurrent ?? false)) Navigator.pop(sheetContext);
          });
        }
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(16.sp, 0, 16.sp, 16.sp),
          children: [
            for (final note in current)
              NoteCard(note: note, title: "$bookName ${verseRange(note.chapter, note.verseStart, note.verseEnd)}"),
          ],
        );
      },
    ),
  );
}

/// A note with its text, and edit / delete buttons.
class NoteCard extends ConsumerWidget {
  const NoteCard({super.key, required this.note, required this.title, this.onOpen});

  final BibleAnnotation note;
  final String title;

  /// When given, a tap on the card opens the verse.
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(bibleAnnotationsProvider.notifier);
    return Card(
      margin: EdgeInsets.only(bottom: 8.sp),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.sp),
        onTap: onOpen,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.sp, 8.sp, 4.sp, 8.sp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.sp),
                    Text(note.note ?? "", style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              IconButton(
                tooltip: "bible_note_edit".i18n(),
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  final text = await showNoteEditor(context, title: title, initial: note.note);
                  if (text != null) {
                    notifier.saveNote(
                      BiblePlace(
                        translation: note.translation,
                        numbering: note.numbering,
                        book: note.book,
                        chapter: note.chapter,
                      ),
                      note.verseStart,
                      note.verseEnd,
                      text,
                      existing: note,
                    );
                  }
                },
              ),
              IconButton(
                tooltip: "bible_note_delete".i18n(),
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  final yes = await showDialog<bool>(
                    context: context,
                    builder: (context) => AdaptiveAlertDialog(
                      content: Text("bible_note_delete_question".i18n()),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: Text("bible_cancel".i18n())),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text("bible_note_delete".i18n()),
                        ),
                      ],
                    ),
                  );
                  if (yes == true) notifier.delete(note.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
