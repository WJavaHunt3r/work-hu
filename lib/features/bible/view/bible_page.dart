import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/bible/data/model/bible_model.dart';
import 'package:work_hu/features/bible/providers/bible_provider.dart';
import 'package:work_hu/features/bible/view/bible_widgets.dart';

/// The Bible (`/bible`): "Continue" at the last chapter read, then a grid of the books (short names, shaded by group:
/// law, history, poetry, prophets, gospels, letters, ...); a book opens to a grid of its chapters, a chapter to a grid
/// of its verses, all on this page (back goes verses → chapters → books), and a verse opens the reader there
/// (`?verse=n`: scrolled to and lit up). The book being read is highlighted, and so is its chapter.
class BiblePage extends ConsumerWidget {
  const BiblePage({super.key});

  /// The route of the Bible page while it is open (underneath a reader, say), so the reader's title can go back to it
  /// past any pages in between (the notes list) instead of to whatever happens to be below (Home).
  static ModalRoute<dynamic>? openRoute;

  /// From a reader: back to the Bible page when it is open, else the Bible page in the reader's place (so back from it
  /// leads where the reader came from, e.g. Home).
  static void showFrom(BuildContext context) {
    final route = openRoute;
    if (route != null && route.isActive) {
      Navigator.of(context).popUntil((r) => r == route);
    } else {
      context.pushReplacement('/bible');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(bibleSelectedBookProvider);
    final chapter = ref.watch(bibleSelectedChapterProvider);
    final id = ref.watch(bibleTranslationIdProvider);
    final selectedName = ref.watch(
      bibleTextProvider(id).select((s) => selected == null ? null : s.bible?.book(selected)?.name),
    );
    // One step back: verses → chapters (a one-chapter book: → books) → books
    void back() {
      final oneChapter = ref.read(bibleTextProvider(id)).bible?.book(selected ?? '')?.chapterCount == 1;
      if (chapter != null && !oneChapter) {
        ref.read(bibleSelectedChapterProvider.notifier).state = null;
      } else {
        ref.read(bibleSelectedChapterProvider.notifier).state = null;
        ref.read(bibleSelectedBookProvider.notifier).state = null;
      }
    }

    return _RememberRoute(
      child: PopScope(
        canPop: selected == null,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) back();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: selected == null ? null : BackButton(onPressed: back),
            title: Text(
              selectedName == null ? "bible_title".i18n() : (chapter == null ? selectedName : "$selectedName $chapter"),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                tooltip: "bible_notes_title".i18n(),
                icon: const Icon(Icons.bookmarks_outlined),
                onPressed: () => context.push('/bible/notes'),
              ),
              const BibleTranslationButton(),
            ],
          ),
          body: BibleTextView(
            builder: (context, bible) {
              final book = selected == null ? null : bible.book(selected);
              if (book == null) return _BookGrid(bible: bible);
              final verses = chapter == null ? null : book.chapter(chapter);
              return verses == null
                  ? _ChapterGrid(book: book)
                  : _VerseGrid(book: book, chapter: chapter!, verses: verses);
            },
          ),
        ),
      ),
    );
  }
}

/// Keeps [BiblePage.openRoute] while the Bible page is in the navigator.
class _RememberRoute extends StatefulWidget {
  const _RememberRoute({required this.child});

  final Widget child;

  @override
  State<_RememberRoute> createState() => _RememberRouteState();
}

class _RememberRouteState extends State<_RememberRoute> {
  ModalRoute<dynamic>? _route;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _route = ModalRoute.of(context);
    BiblePage.openRoute = _route;
  }

  @override
  void dispose() {
    if (BiblePage.openRoute == _route) BiblePage.openRoute = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// The group a book belongs to, for its shade: law, history, poetry, major prophets, minor prophets, gospels, Acts,
/// Paul's letters, the other letters, Revelation.
int bookGroup(int bookId) => switch (bookId) {
  <= 5 => 0,
  <= 17 => 1,
  <= 22 => 2,
  <= 27 => 3,
  <= 39 => 4,
  <= 43 => 5,
  44 => 6,
  <= 57 => 7,
  <= 65 => 8,
  _ => 9,
};

/// How strongly each group is tinted with the primary color; neighbouring groups differ.
const _groupTint = [0.10, 0.34, 0.18, 0.26, 0.44, 0.10, 0.34, 0.20, 0.30, 0.48];

class _BookGrid extends ConsumerWidget {
  const _BookGrid({required this.bible});

  final Bible bible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(biblePositionProvider);
    final continueBook = position == null ? null : bible.book(position.osis);
    final colors = Theme.of(context).colorScheme;

    void open(BibleBook book) {
      ref.read(bibleSelectedBookProvider.notifier).state = book.osis;
      // A book of one chapter (Obadiah, Philemon, Jude, ...) needs no chapter grid: straight to its verses
      ref.read(bibleSelectedChapterProvider.notifier).state = book.chapterCount == 1 ? 1 : null;
    }

    List<Widget> section(String title, Iterable<BibleBook> books) => [
      _SectionHeader(title),
      _Grid(
        columns: 5,
        aspectRatio: 1.45,
        children: [
          for (final book in books)
            _Tile(
              label: book.abbreviation,
              tooltip: book.name,
              color: Color.alphaBlend(
                colors.primary.withValues(alpha: _groupTint[bookGroup(book.bookId)]),
                colors.surface,
              ),
              current: book.osis == position?.osis,
              onTap: () => open(book),
            ),
        ],
      ),
    ];

    return ListView(
      padding: EdgeInsets.only(bottom: 24.sp),
      children: [
        if (continueBook != null && continueBook.chapter(position!.chapter) != null)
          Padding(
            padding: EdgeInsets.fromLTRB(8.sp, 8.sp, 8.sp, 4.sp),
            child: Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.sp),
                leading: const Icon(Icons.menu_book),
                title: Text("bible_continue".i18n(["${continueBook.name} ${position.chapter}"])),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(position.route),
              ),
            ),
          ),
        ...section("bible_old_testament".i18n(), bible.books.where((b) => !b.newTestament)),
        ...section("bible_new_testament".i18n(), bible.books.where((b) => b.newTestament)),
      ],
    );
  }
}

class _ChapterGrid extends ConsumerWidget {
  const _ChapterGrid({required this.book});

  final BibleBook book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(biblePositionProvider);
    final colors = Theme.of(context).colorScheme;
    final color = Color.alphaBlend(
      colors.primary.withValues(alpha: _groupTint[bookGroup(book.bookId)]),
      colors.surface,
    );
    return ListView(
      padding: EdgeInsets.only(bottom: 24.sp),
      children: [
        _SectionHeader("bible_chapters".i18n()),
        _Grid(
          columns: 6,
          aspectRatio: 1.2,
          children: [
            for (var c = 1; c <= book.chapterCount; c++)
              _Tile(
                label: "$c",
                color: color,
                current: position == BiblePosition(book.osis, c),
                onTap: () => ref.read(bibleSelectedChapterProvider.notifier).state = c,
              ),
          ],
        ),
      ],
    );
  }
}

/// The verses of a chapter (the numbers the translation has: WEB leaves some out); a verse opens the reader there.
class _VerseGrid extends ConsumerWidget {
  const _VerseGrid({required this.book, required this.chapter, required this.verses});

  final BibleBook book;
  final int chapter;
  final List<Verse> verses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final color = Color.alphaBlend(
      colors.primary.withValues(alpha: _groupTint[bookGroup(book.bookId)]),
      colors.surface,
    );
    void open(int verse) {
      // Back from the reader: the chapters (a one-chapter book: the books), not this grid again. Set before opening,
      // as the reader's previous / next replace it, so waiting for it to close would never end.
      ref.read(bibleSelectedChapterProvider.notifier).state = null;
      if (book.chapterCount == 1) ref.read(bibleSelectedBookProvider.notifier).state = null;
      context.push('${BiblePosition(book.osis, chapter).route}?verse=$verse');
    }

    return ListView(
      padding: EdgeInsets.only(bottom: 24.sp),
      children: [
        _SectionHeader("bible_verses".i18n()),
        _Grid(
          columns: 6,
          aspectRatio: 1.2,
          children: [
            for (final v in verses)
              _Tile(label: "${v.number}", color: color, current: false, onTap: () => open(v.number)),
          ],
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.fromLTRB(8.sp, 8.sp, 8.sp, 4.sp),
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
      decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(4.sp)),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.columns, required this.aspectRatio, required this.children});

  final int columns;
  final double aspectRatio;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: columns,
      childAspectRatio: aspectRatio,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 8.sp),
      mainAxisSpacing: 3.sp,
      crossAxisSpacing: 3.sp,
      children: children,
    );
  }
}

/// One book or chapter. [current] = the one being read: filled with the primary color.
class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.color, required this.current, required this.onTap, this.tooltip});

  final String label;
  final String? tooltip;
  final Color color;
  final bool current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tile = Material(
      color: current ? theme.colorScheme.primary : color,
      borderRadius: BorderRadius.circular(4.sp),
      child: InkWell(
        borderRadius: BorderRadius.circular(4.sp),
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.sp),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: current ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return tooltip == null ? tile : Tooltip(message: tooltip!, child: tile);
  }
}
