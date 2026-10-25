import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/bible/data/model/bible_annotation.dart';
import 'package:work_hu/features/bible/data/model/bible_model.dart';
import 'package:work_hu/features/bible/providers/bible_annotations_provider.dart';
import 'package:work_hu/features/bible/view/bible_annotation_widgets.dart';
import 'package:work_hu/features/bible/view/bible_widgets.dart';

/// The user's bookmarks, notes and highlights (`/bible/notes`), in Bible order, named in the active translation; a
/// tap opens the chapter at the verse.
class BibleAnnotationsPage extends ConsumerWidget {
  const BibleAnnotationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final annotations = ref.watch(bibleAnnotationsProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("bible_notes_title".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
            tabs: [
              Tab(text: "bible_tab_bookmarks".i18n()),
              Tab(text: "bible_tab_notes".i18n()),
              Tab(text: "bible_tab_highlights".i18n()),
            ],
          ),
        ),
        body: BibleTextView(
          builder: (context, bible) {
            List<BibleAnnotation> ofType(BibleAnnotationType type) => _inBibleOrder(bible, [
              for (final a in annotations.values)
                if (a.type == type && bible.book(a.book) != null) a,
            ]);
            return TabBarView(
              children: [
                _AnnotationList(
                  bible: bible,
                  items: ofType(BibleAnnotationType.bookmark),
                  empty: "bible_empty_bookmarks".i18n(),
                ),
                _AnnotationList(
                  bible: bible,
                  items: ofType(BibleAnnotationType.note),
                  empty: "bible_empty_notes".i18n(),
                ),
                _AnnotationList(
                  bible: bible,
                  items: ofType(BibleAnnotationType.highlight),
                  empty: "bible_empty_highlights".i18n(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static List<BibleAnnotation> _inBibleOrder(Bible bible, List<BibleAnnotation> items) => items
    ..sort((a, b) {
      final byBook = bible.book(a.book)!.bookId.compareTo(bible.book(b.book)!.bookId);
      if (byBook != 0) return byBook;
      final byChapter = a.chapter.compareTo(b.chapter);
      return byChapter != 0 ? byChapter : a.verseStart.compareTo(b.verseStart);
    });
}

class _AnnotationList extends StatelessWidget {
  const _AnnotationList({required this.bible, required this.items, required this.empty});

  final Bible bible;
  final List<BibleAnnotation> items;
  final String empty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.sp),
          child: Text(
            empty,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.hintColor),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(12.sp),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final a = items[i];
        final book = bible.book(a.book)!;
        final title = "${book.name} ${verseRange(a.chapter, a.verseStart, a.verseEnd)}";
        void open() => context.push('/bible/${a.book}/${a.chapter}?verse=${a.verseStart}');
        if (a.type == BibleAnnotationType.note) return NoteCard(note: a, title: title, onOpen: open);
        // The verse text, where the mark's verses can be placed in this translation (same numbering, or a known rule)
        final verses = book.chapter(a.chapter);
        final range = verses == null || verses.isEmpty
            ? null
            : shownRange(a, book.numberingOf(a.chapter), lastVerse: verses.last.number);
        final text = range == null || !range.exact
            ? null
            : verses!.where((v) => v.number >= range.start && v.number <= range.end).map((v) => v.text).join(" ");
        return Card(
          margin: EdgeInsets.only(bottom: 8.sp),
          color: a.color == null ? null : highlightBackground(context, a.color!),
          child: ListTile(
            // the app's ListTile theme has no padding
            contentPadding: EdgeInsets.symmetric(horizontal: 16.sp),
            leading: a.type == BibleAnnotationType.bookmark
                ? Icon(Icons.bookmark, color: theme.colorScheme.primary)
                : null,
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: text == null || text.isEmpty ? null : Text(text, maxLines: 3, overflow: TextOverflow.ellipsis),
            onTap: open,
          ),
        );
      },
    );
  }
}
