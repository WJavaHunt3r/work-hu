import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/bible/data/api/bible_annotation_api.dart';
import 'package:work_hu/features/bible/data/api/bible_api.dart';
import 'package:work_hu/features/bible/data/model/bible_annotation.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/bible/providers/bible_annotations_provider.dart';
import 'package:work_hu/features/bible/view/bible_annotations_page.dart';
import 'package:work_hu/features/bible/data/model/bible_model.dart';
import 'package:work_hu/features/bible/data/repository/bible_repository.dart';
import 'package:work_hu/features/bible/data/store/bible_store_io.dart';
import 'package:work_hu/features/bible/data/store/bible_store_memory.dart';
import 'package:work_hu/features/bible/providers/bible_provider.dart';
import 'package:work_hu/features/bible/view/bible_chapter_page.dart';
import 'package:work_hu/features/bible/view/bible_page.dart';

/// A small translation in the backend's format: Genesis (2 chapters), Exodus (1), John (1).
Uint8List bibleJson(String id, {String prefix = '', String? johnNumbering, bool johnVerse2 = false}) =>
    Uint8List.fromList(
      utf8.encode(
        jsonEncode({
          'id': id,
          'name': 'Bible $id',
          'language': 'hu',
          'books': [
            {
              'book': 'Gen',
              'bookId': 1,
              'name': '1 Mózes',
              'abbreviation': '1Móz',
              'englishName': 'Genesis',
              'testament': 'OT',
              'chapters': [
                {
                  'chapter': 1,
                  'verses': [
                    {'number': 1, 'text': '${prefix}Kezdetben'},
                    {'number': 2, 'text': 'A föld pedig'},
                  ],
                },
                {
                  'chapter': 2,
                  'verses': [
                    {
                      'number': 1,
                      'text':
                          '$prefix'
                          'Így lőnek elvégezve',
                    },
                  ],
                },
              ],
            },
            {
              'book': 'Exod',
              'bookId': 2,
              'name': '2 Mózes',
              'abbreviation': '2Móz',
              'englishName': 'Exodus',
              'testament': 'OT',
              'chapters': [
                {
                  'chapter': 1,
                  'verses': [
                    {'number': 1, 'text': '${prefix}Ezek pedig'},
                  ],
                },
              ],
            },
            {
              'book': 'John',
              'bookId': 43,
              'name': 'János',
              'abbreviation': 'Ján',
              'englishName': 'John',
              'testament': 'NT',
              'chapters': [
                {
                  'chapter': 1,
                  'numbering': ?johnNumbering,
                  'verses': [
                    {'number': 1, 'text': '${prefix}Kezdetben vala az Ige'},
                    if (johnVerse2) {'number': 2, 'text': '${prefix}Ez kezdetben az Istennél vala'},
                    // a verse left out by the translation
                    {'number': 3, 'text': 'Minden ő általa lett'},
                  ],
                },
              ],
            },
          ],
        }),
      ),
    );

class FakeBibleApi implements BibleApi {
  final downloads = <String>[];
  bool offline = false;
  final versions = {'kar': 'v1', 'kjv': 'k1'};

  @override
  Future<List<dynamic>> getTranslations() async {
    if (offline) throw Exception('offline');
    return [
      {
        'id': 'kar',
        'shortName': 'Károli',
        'name': 'Károli Biblia',
        'language': 'hu',
        'year': 1908,
        'version': versions['kar'],
        'size': 1471578,
      },
      {
        'id': 'kjv',
        'shortName': 'KJV',
        'name': 'King James Version',
        'language': 'en',
        'year': 1769,
        'version': versions['kjv'],
        'size': 1310989,
      },
    ];
  }

  @override
  Future<Uint8List> getText(String id) async {
    if (offline) throw Exception('offline');
    downloads.add(id);
    return id == 'kjv' ? bibleJson(id, prefix: 'KJV ', johnVerse2: true) : bibleJson(id, johnNumbering: 'kar');
  }
}

Future<Bible> parseNow(Uint8List json) async => parseBible(json);

class FakeUserProvider extends ChangeNotifier implements UserProvider {
  FakeUserProvider([this.id = 5]);

  final int id;

  @override
  UserModel? get user => UserModel(id: id, firstname: 'Test', lastname: 'User', role: Role.USER, changedPassword: true);

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// The annotation backend in memory, with its rules: saves by id, deletions as tombstones, changes since a time.
class FakeAnnotationApi implements BibleAnnotationApi {
  final rows = <String, Map<String, dynamic>>{};
  final calls = <String>[];
  bool offline = false;
  int clock = 0;

  /// How long the server takes to answer a sync (a real one answers while animations still run).
  Duration delay = Duration.zero;

  /// Answers every request with this status (e.g. 404: a backend without the endpoints yet).
  int? failWith;

  DioException _status(String path, int status) => DioException(
    requestOptions: RequestOptions(path: path),
    response: Response(
      requestOptions: RequestOptions(path: path),
      statusCode: status,
    ),
    type: DioExceptionType.badResponse,
  );

  DioException _offline(String path) => DioException(
    requestOptions: RequestOptions(path: path),
    type: DioExceptionType.connectionError,
  );

  String _time(int t) => DateTime.utc(2026, 10, 24, 12).add(Duration(seconds: t)).toIso8601String();

  @override
  Future<Map<String, dynamic>> getChanges(String? since) async {
    if (offline) throw _offline('/bible/annotations');
    if (failWith != null) throw _status('/bible/annotations', failWith!);
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    calls.add(since == null ? 'get all' : 'get since');
    final list = rows.values
        .where((r) => since == null ? r['deleted'] != true : r['updatedAt'].compareTo(since) >= 0)
        .toList();
    return {'next': _time(clock), 'annotations': list};
  }

  @override
  Future<void> save(String id, Map<String, dynamic> annotation) async {
    if (offline) throw _offline('/bible/annotations/$id');
    if (failWith != null) throw _status('/bible/annotations/$id', failWith!);
    calls.add('put ${annotation['type']} ${annotation['verseStart']}');
    rows[id] = {...annotation, 'deleted': false, 'updatedAt': _time(++clock)};
  }

  @override
  Future<void> delete(String id) async {
    if (offline) throw _offline('/bible/annotations/$id');
    calls.add('delete');
    final r = rows[id];
    if (r != null) rows[id] = {...r, 'deleted': true, 'note': null, 'updatedAt': _time(++clock)};
  }

  /// Another device of the same user saved something.
  void savedElsewhere(String id, String type, int verse, {String? color, String? note}) => rows[id] = {
    'id': id,
    'type': type,
    'translation': 'kar',
    'numbering': 'kjv',
    'book': 'Gen',
    'chapter': 1,
    'verseStart': verse,
    'verseEnd': verse,
    'color': color,
    'note': note,
    'deleted': false,
    'updatedAt': _time(++clock),
  };
}

Future<void> pumpBible(
  WidgetTester tester, {
  required FakeBibleApi api,
  MemoryBibleStore? store,
  FakeAnnotationApi? annotations,
  String location = '/bible',
}) async {
  final router = GoRouter(
    initialLocation: location,
    routes: [
      // Home's "Continue" opens the reader straight away, without the Bible page underneath
      GoRoute(
        path: '/home',
        builder: (context, state) => Scaffold(
          body: TextButton(onPressed: () => context.push('/bible/Gen/1'), child: const Text('Continue')),
        ),
      ),
      GoRoute(
        path: '/bible',
        builder: (context, state) => const BiblePage(),
        routes: [
          GoRoute(path: 'notes', builder: (context, state) => const BibleAnnotationsPage()),
          GoRoute(
            path: ':book/:chapter',
            builder: (context, state) => BibleChapterPage(
              osis: state.pathParameters['book']!,
              chapter: int.parse(state.pathParameters['chapter']!),
              focusVerse: int.tryParse(state.uri.queryParameters['verse'] ?? ''),
            ),
          ),
        ],
      ),
    ],
  );
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        bibleRepoProvider.overrideWithValue(BibleRepository(api, store ?? MemoryBibleStore(), parse: parseNow)),
        bibleAnnotationApiProvider.overrideWithValue(annotations ?? FakeAnnotationApi()),
        userDataProvider.overrideWith((ref) => FakeUserProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        builder: (context, child) => MaterialApp.router(routerConfig: router),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    LocalJsonLocalization.delegate.directories = ['lib/I18n'];
    await LocalJsonLocalization.delegate.load(const Locale('hu', 'HU'));
  });

  setUp(() => SharedPreferences.setMockInitialValues({'appLocale': 'hu'}));

  group('BiblePosition', () {
    final bible = parseBible(bibleJson('kar'));

    test('moves across books and stops at the ends', () {
      expect(const BiblePosition('Gen', 1).previous(bible), isNull);
      expect(const BiblePosition('Gen', 1).next(bible), const BiblePosition('Gen', 2));
      expect(const BiblePosition('Gen', 2).next(bible), const BiblePosition('Exod', 1));
      expect(const BiblePosition('Exod', 1).previous(bible), const BiblePosition('Gen', 2));
      expect(const BiblePosition('John', 1).next(bible), isNull);
    });

    test('is remembered as "John.3"', () {
      expect(const BiblePosition('1John', 3).encode(), '1John.3');
      expect(BiblePosition.decode('1John.3'), const BiblePosition('1John', 3));
      expect(BiblePosition.decode('John'), isNull);
      expect(BiblePosition.decode(null), isNull);
    });

    test('the year is added to a name only when it lacks it', () {
      const karoli = BibleTranslationInfo(
        id: 'kar',
        shortName: 'Károli',
        name: 'Károli Biblia',
        language: 'hu',
        year: 1908,
      );
      const luther = BibleTranslationInfo(
        id: 'luth1912',
        shortName: 'Luther',
        name: 'Lutherbibel 1912',
        language: 'de',
        year: 1912,
      );
      expect(karoli.fullName, 'Károli Biblia (1908)');
      expect(luther.fullName, 'Lutherbibel 1912');
    });

    test('keeps the verse numbers of the text', () {
      expect(bible.book('John')!.chapter(1)!.map((v) => v.number), [1, 3]);
      expect(bible.book('John')!.chapter(2), isNull);
      expect(bible.book('Rev'), isNull);
    });
  });

  test('the file store keeps the text and its version', () async {
    final dir = await Directory.systemTemp.createTemp('bible');
    addTearDown(() => dir.delete(recursive: true));
    final store = FileBibleStore(dir);

    expect(await store.load('kar'), isNull);
    await store.save('kar', bibleJson('kar'), 'v1');

    final loaded = await store.load('kar');
    expect(loaded!.version, 'v1');
    expect(loaded.json, bibleJson('kar'));
    expect(await store.downloaded(), {'kar'});
    // kept gzipped
    expect(File('${dir.path}/kar.json.gz').lengthSync(), lessThan(bibleJson('kar').length));
  });

  testWidgets('the first visit downloads the translation of the app language and shows its books as a grid', (
    tester,
  ) async {
    final api = FakeBibleApi();
    await pumpBible(tester, api: api);

    expect(api.downloads, ['kar']);
    expect(find.text('Ószövetség'), findsOneWidget);
    expect(find.text('Újszövetség'), findsOneWidget);
    expect(find.text('1Móz'), findsOneWidget);
    expect(find.text('Ján'), findsOneWidget);
    expect(find.textContaining('Folytatás'), findsNothing);

    // a book opens to its chapters on the same page
    await tester.tap(find.text('1Móz'));
    await tester.pumpAndSettle();
    expect(find.text('1 Mózes'), findsOneWidget);
    expect(find.text('Fejezetek'), findsOneWidget);
    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();

    // then its verses, and a verse opens the reader there
    expect(find.text('1 Mózes 2'), findsOneWidget);
    expect(find.text('Versek'), findsOneWidget);
    await tester.tap(find.text('1'));
    await tester.pumpAndSettle();

    expect(find.text('1Móz 2'), findsOneWidget);
    expect(find.text('Így lőnek elvégezve'), findsOneWidget);
    expect((await SharedPreferences.getInstance()).getString('bible_position'), 'Gen.2');

    // next goes on to the next book
    await tester.tap(find.text('2 Mózes 1'));
    await tester.pumpAndSettle();
    expect(find.text('Ezek pedig'), findsOneWidget);

    // back: the chapters of the book picked, then the books with "Continue"
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Fejezetek'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Folytatás: 2 Mózes 1'), findsOneWidget);
    expect(api.downloads, ['kar']);
  });

  testWidgets('a book of one chapter goes straight to its verses, and the title leads to the book grid', (
    tester,
  ) async {
    await pumpBible(tester, api: FakeBibleApi());

    await tester.tap(find.text('2Móz'));
    await tester.pumpAndSettle();
    expect(find.text('2 Mózes 1'), findsOneWidget); // the page's title
    expect(find.text('Versek'), findsOneWidget);
    expect(find.text('Fejezetek'), findsNothing);
    await tester.tap(find.text('1'));
    await tester.pumpAndSettle();
    expect(find.text('Ezek pedig'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3)); // the verse is lit up for two seconds

    await tester.tap(find.text('2Móz 1'));
    await tester.pumpAndSettle();
    expect(find.text('Ószövetség'), findsOneWidget);
    final current = tester.widget<Material>(
      find.ancestor(of: find.text('2Móz'), matching: find.byType(Material)).first,
    );
    expect(current.color, Theme.of(tester.element(find.text('2Móz'))).colorScheme.primary);

    // back steps through the grids before leaving the page
    await tester.tap(find.text('Ján'));
    await tester.pumpAndSettle();
    expect(find.text('Versek'), findsOneWidget);
    expect(find.text('3'), findsOneWidget); // only the verses the translation has: 1 and 3
    expect(find.text('2'), findsNothing);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Ószövetség'), findsOneWidget);
  });

  testWidgets('a copy on the device is read without downloading while its version is current', (tester) async {
    final api = FakeBibleApi();
    final store = MemoryBibleStore();
    await store.save('kar', bibleJson('kar', prefix: 'Régi '), 'v1');
    await pumpBible(tester, api: api, store: store, location: '/bible/Gen/1');

    expect(find.text('Régi Kezdetben'), findsOneWidget);
    expect(api.downloads, isEmpty);
  });

  testWidgets('a newer version is downloaded and replaces the copy on the device', (tester) async {
    final api = FakeBibleApi();
    final store = MemoryBibleStore();
    await store.save('kar', bibleJson('kar', prefix: 'Régi '), 'v0');
    await pumpBible(tester, api: api, store: store, location: '/bible/Gen/1');

    expect(api.downloads, ['kar']);
    expect(find.text('Kezdetben'), findsOneWidget);
    expect((await store.load('kar'))!.version, 'v1');
  });

  testWidgets('offline, the copy on the device is still read', (tester) async {
    final api = FakeBibleApi()..offline = true;
    final store = MemoryBibleStore();
    await store.save('kar', bibleJson('kar'), 'v0');
    await pumpBible(tester, api: api, store: store, location: '/bible/John/1');

    expect(find.text('Kezdetben vala az Ige'), findsOneWidget);
  });

  testWidgets('without a copy and a connection it says so, and retrying downloads it', (tester) async {
    final api = FakeBibleApi()..offline = true;
    await pumpBible(tester, api: api);

    expect(find.textContaining('nem sikerült letölteni'), findsOneWidget);

    api.offline = false;
    await tester.tap(find.text('Újra'));
    await tester.pumpAndSettle();
    expect(find.text('1Móz'), findsOneWidget);
  });

  testWidgets('another translation is downloaded when picked, and the pick is remembered', (tester) async {
    final api = FakeBibleApi();
    await pumpBible(tester, api: api, location: '/bible/Gen/1');

    expect(find.text('Károli'), findsOneWidget);
    await tester.tap(find.text('Károli'));
    await tester.pumpAndSettle();
    expect(find.text('1.3 MB'), findsOneWidget); // not downloaded yet: its size

    await tester.tap(find.text('King James Version (1769)'));
    await tester.pumpAndSettle();

    expect(api.downloads, ['kar', 'kjv']);
    expect(find.text('KJV Kezdetben'), findsOneWidget);
    expect((await SharedPreferences.getInstance()).getString('bible_translation'), 'kjv');
  });

  testWidgets('a chapter the translation lacks says so', (tester) async {
    await pumpBible(tester, api: FakeBibleApi(), location: '/bible/John/5');

    expect(find.text('Ez a fejezet nincs meg ebben a fordításban.'), findsOneWidget);
  });

  testWidgets('parallel reading shows a second translation side by side, verse by verse, and is remembered', (
    tester,
  ) async {
    final api = FakeBibleApi();
    await pumpBible(tester, api: api, location: '/bible/John/1');

    await tester.tap(find.byIcon(Icons.vertical_split_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Károli Biblia (1908)'), findsNothing); // not offered as its own pair
    await tester.tap(find.text('King James Version (1769)'));
    await tester.pumpAndSettle();

    expect(api.downloads, ['kar', 'kjv']);
    expect((await SharedPreferences.getInstance()).getString('bible_parallel'), 'kjv');
    expect(find.text('Bible kar'), findsOneWidget);
    expect(find.text('Bible kjv'), findsOneWidget);

    // verse 1 of both in one row; verse 2 only in KJV, its Károli cell is empty
    final row1 = find.ancestor(of: find.text('KJV Kezdetben vala az Ige'), matching: find.byType(Row));
    expect(find.descendant(of: row1.last, matching: find.text('Kezdetben vala az Ige')), findsOneWidget);
    expect(find.text('KJV Ez kezdetben az Istennél vala'), findsOneWidget);
    // the two translations number this chapter differently
    expect(find.textContaining('másként számozza'), findsOneWidget);

    // the same numbers: no note
    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    expect(find.text('2Móz 1'), findsOneWidget);
    expect(find.text('KJV Ezek pedig'), findsOneWidget);
    expect(find.textContaining('másként számozza'), findsNothing);

    await tester.tap(find.byIcon(Icons.vertical_split_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kikapcsolva'));
    await tester.pumpAndSettle();
    expect(find.textContaining('KJV'), findsNothing);
    expect(find.text('Ezek pedig'), findsOneWidget);
    expect((await SharedPreferences.getInstance()).getString('bible_parallel'), '');
  });

  testWidgets('the parallel translation is switched off when it becomes the active one', (tester) async {
    SharedPreferences.setMockInitialValues({'appLocale': 'hu', 'bible_parallel': 'kjv', 'bible_translation': 'kjv'});
    await pumpBible(tester, api: FakeBibleApi(), location: '/bible/Gen/1');

    expect(find.text('KJV Kezdetben'), findsOneWidget);
    expect(find.text('Bible kar'), findsNothing);
  });

  group('highlights, notes and bookmarks', () {
    /// The background of the verse tile showing [text], or null.
    Color? background(WidgetTester tester, String text) {
      final box = tester.widget<AnimatedContainer>(
        find.ancestor(of: find.text(text), matching: find.byType(AnimatedContainer)).first,
      );
      return (box.decoration as BoxDecoration?)?.color;
    }

    testWidgets('selected verses are highlighted, saved on the server and the highlight can be taken away', (
      tester,
    ) async {
      final server = FakeAnnotationApi();
      await pumpBible(tester, api: FakeBibleApi(), annotations: server, location: '/bible/Gen/1');

      await tester.tap(find.text('Kezdetben'));
      await tester.tap(find.text('A föld pedig'));
      await tester.pumpAndSettle();
      expect(find.text('1Móz 1:1-2'), findsOneWidget); // the selection bar

      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is Container && (w.decoration as BoxDecoration?)?.color == HighlightColor.green.color,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1Móz 1:1-2'), findsNothing);
      expect(background(tester, 'Kezdetben'), isNotNull);
      expect(background(tester, 'A föld pedig'), isNotNull);
      expect(server.calls, containsAllInOrder(['get all', 'put HIGHLIGHT 1', 'put HIGHLIGHT 2']));
      expect(server.rows.values.map((r) => r['color']), everyElement('green'));

      await tester.tap(find.text('Kezdetben'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.format_color_reset));
      await tester.pumpAndSettle();
      expect(background(tester, 'Kezdetben'), isNull);
      expect(background(tester, 'A föld pedig'), isNotNull);
      expect(server.rows.values.where((r) => r['deleted'] == true), hasLength(1));
    });

    testWidgets('a note is written on a verse, shown by an icon, edited and deleted', (tester) async {
      final server = FakeAnnotationApi()..delay = const Duration(milliseconds: 100);
      await pumpBible(tester, api: FakeBibleApi(), annotations: server, location: '/bible/Gen/1');

      await tester.tap(find.text('A föld pedig'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit_note));
      await tester.pumpAndSettle();
      expect(find.text('1 Mózes 1:2'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Üres és puszta');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mentés'));
      await tester.pumpAndSettle();

      expect(server.rows.values.single['note'], 'Üres és puszta');
      await tester.tap(find.byIcon(Icons.sticky_note_2_outlined));
      await tester.pumpAndSettle();
      expect(find.text('Üres és puszta'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Kietlen');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mentés'));
      await tester.pumpAndSettle();
      expect(server.rows.values.single['note'], 'Kietlen');
      expect(find.text('Kietlen'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Törlés'));
      await tester.pumpAndSettle();
      expect(server.rows.values.single['deleted'], isTrue);
      expect(find.byIcon(Icons.sticky_note_2_outlined), findsNothing);
      // only the sheet closes: the chapter stays open
      expect(find.byType(BottomSheet), findsNothing);
      expect(find.text('1Móz 1'), findsOneWidget);
      expect(find.text('A föld pedig'), findsOneWidget);
    });

    testWidgets('bookmarks and copying', (tester) async {
      final server = FakeAnnotationApi();
      await pumpBible(tester, api: FakeBibleApi(), annotations: server, location: '/bible/Gen/1');

      await tester.tap(find.text('A föld pedig'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.bookmark_add_outlined));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
      expect(server.rows.values.single['type'], 'BOOKMARK');

      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.setData') copied = (call.arguments as Map)['text'] as String;
        return null;
      });
      addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
      await tester.tap(find.text('Kezdetben'));
      await tester.tap(find.text('A föld pedig'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.copy));
      await tester.pumpAndSettle();
      expect(copied, '1 Mózes 1:1-2\n1 Kezdetben\n2 A föld pedig\n(Bible kar)');
    });

    testWidgets('offline, changes are kept and sent at the next sync; other devices\' changes arrive', (tester) async {
      final server = FakeAnnotationApi()..offline = true;
      await pumpBible(tester, api: FakeBibleApi(), annotations: server, location: '/bible/Gen/1');

      await tester.tap(find.text('Kezdetben'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.bookmark_add_outlined));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.bookmark), findsOneWidget); // shown at once
      expect(server.rows, isEmpty);
      final saved = (await SharedPreferences.getInstance()).getString('bible_annotations_5')!;
      expect(jsonDecode(saved)['pending'], hasLength(1));

      server.offline = false;
      server.savedElsewhere('11111111-1111-4111-8111-111111111111', 'HIGHLIGHT', 2, color: 'pink');
      final container = ProviderScope.containerOf(tester.element(find.byType(BibleChapterPage)));
      await container.read(bibleAnnotationsProvider.notifier).sync();
      await tester.pumpAndSettle();

      expect(server.rows.values.where((r) => r['type'] == 'BOOKMARK'), hasLength(1));
      expect(background(tester, 'A föld pedig'), isNotNull);
      expect(jsonDecode((await SharedPreferences.getInstance()).getString('bible_annotations_5')!)['pending'], isEmpty);

      // deleted elsewhere: gone here at the next sync
      server.rows['11111111-1111-4111-8111-111111111111']!
        ..['deleted'] = true
        ..['updatedAt'] = '2026-10-24T13:00:00.000Z';
      await container.read(bibleAnnotationsProvider.notifier).sync();
      await tester.pumpAndSettle();
      expect(background(tester, 'A föld pedig'), isNull);
    });

    testWidgets('a backend without the endpoints (404) keeps changes queued; a real refusal (400) drops them', (
      tester,
    ) async {
      final server = FakeAnnotationApi()..failWith = 404;
      await pumpBible(tester, api: FakeBibleApi(), annotations: server, location: '/bible/Gen/1');

      await tester.tap(find.text('Kezdetben'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.bookmark_add_outlined));
      await tester.pumpAndSettle();
      var stored = jsonDecode((await SharedPreferences.getInstance()).getString('bible_annotations_5')!);
      expect(stored['pending'], hasLength(1)); // kept for later

      server.failWith = 400;
      final container = ProviderScope.containerOf(tester.element(find.byType(BibleChapterPage)));
      await container.read(bibleAnnotationsProvider.notifier).sync();
      await tester.pumpAndSettle();
      stored = jsonDecode((await SharedPreferences.getInstance()).getString('bible_annotations_5')!);
      expect(stored['pending'], isEmpty); // refused for good
    });

    test('marks are placed by the numbering rule', () {
      expect(mapVerse(5, 'kjv', 'kjv'), (verse: 5, exact: true));
      expect(mapVerse(1, 'heb', 'kjv'), (verse: 1, exact: true)); // the title goes into verse 1
      expect(mapVerse(5, 'heb', 'kjv'), (verse: 4, exact: true));
      expect(mapVerse(4, 'kjv', 'heb'), (verse: 5, exact: true));
      expect(mapVerse(5, 'kar', 'kjv'), (verse: 5, exact: false)); // no rule: kept, labelled
      const late = BibleAnnotation(
        id: 'x',
        type: BibleAnnotationType.note,
        translation: 'kar',
        numbering: 'heb',
        book: 'Ps',
        chapter: 3,
        verseStart: 9,
        verseEnd: 9,
      );
      expect(shownRange(late, 'heb', lastVerse: 8), (start: 8, end: 8, exact: true)); // Norsk runs 3:9 into 3:8
    });

    testWidgets('a mark made in another numbering is moved by the rule, or kept and labelled', (tester) async {
      final server = FakeAnnotationApi()
        // made where the title is verse 1: verse 2 there is verse 1 here
        ..savedElsewhere('22222222-2222-4222-8222-222222222222', 'HIGHLIGHT', 2, color: 'yellow')
        // Károli's own numbering: no rule, kept at verse 2 with a label
        ..savedElsewhere('33333333-3333-4333-8333-333333333333', 'BOOKMARK', 2);
      server.rows['22222222-2222-4222-8222-222222222222']!['numbering'] = 'heb';
      server.rows['33333333-3333-4333-8333-333333333333']!['numbering'] = 'kar';
      await pumpBible(tester, api: FakeBibleApi(), annotations: server, location: '/bible/Gen/1');

      expect(background(tester, 'Kezdetben'), isNotNull);
      expect(background(tester, 'A föld pedig'), isNull);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
      expect(find.text('jelölés Károli számozása szerint'), findsOneWidget);

      // changing the shown highlight changes that mark, it isn't doubled
      await tester.tap(find.text('Kezdetben'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('blue'));
      await tester.pumpAndSettle();
      final highlights = server.rows.values.where((r) => r['type'] == 'HIGHLIGHT' && r['deleted'] != true).toList();
      expect(highlights, hasLength(1));
      expect(highlights.single['color'], 'blue');
      expect(highlights.single['numbering'], 'heb');

      // and "no colour" takes it away
      await tester.tap(find.text('Kezdetben'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.format_color_reset));
      await tester.pumpAndSettle();
      expect(background(tester, 'Kezdetben'), isNull);
      expect(server.rows['22222222-2222-4222-8222-222222222222']!['deleted'], isTrue);
    });

    testWidgets('the list shows bookmarks, notes and highlights in Bible order and opens the verse', (tester) async {
      final server = FakeAnnotationApi()
        ..savedElsewhere('33333333-3333-4333-8333-333333333333', 'BOOKMARK', 2)
        ..savedElsewhere('44444444-4444-4444-8444-444444444444', 'NOTE', 1, note: 'Teremtés')
        ..savedElsewhere('55555555-5555-4555-8555-555555555555', 'HIGHLIGHT', 1, color: 'blue');
      await pumpBible(tester, api: FakeBibleApi(), annotations: server, location: '/bible/notes');

      expect(find.text('1 Mózes 1:2'), findsOneWidget);
      expect(find.text('A föld pedig'), findsOneWidget); // the verse text

      await tester.tap(find.text('Jegyzetek'));
      await tester.pumpAndSettle();
      expect(find.text('Teremtés'), findsOneWidget);

      await tester.tap(find.text('Kiemelések'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('1 Mózes 1:1'));
      await tester.pumpAndSettle();
      expect(find.text('1Móz 1'), findsOneWidget);
      expect(background(tester, 'Kezdetben'), isNotNull);
      await tester.pump(const Duration(seconds: 3)); // the verse is lit up for two seconds
    });

    testWidgets('another user on the same phone does not see them', (tester) async {
      SharedPreferences.setMockInitialValues({
        'appLocale': 'hu',
        'bible_annotations_9': jsonEncode({
          'items': [
            {
              'id': '66666666-6666-4666-8666-666666666666',
              'type': 'HIGHLIGHT',
              'translation': 'kar',
              'numbering': 'kjv',
              'book': 'Gen',
              'chapter': 1,
              'verseStart': 1,
              'verseEnd': 1,
              'color': 'yellow',
            },
          ],
          'pending': {},
        }),
      });
      await pumpBible(tester, api: FakeBibleApi(), annotations: FakeAnnotationApi(), location: '/bible/Gen/1');

      expect(background(tester, 'Kezdetben'), isNull); // user 5 is signed in, the copy belongs to user 9
    });
  });

  group('the reader\'s title', () {
    testWidgets('opened from Home: the book picker takes the reader\'s place, and back returns Home', (tester) async {
      await pumpBible(tester, api: FakeBibleApi(), location: '/home');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Kezdetben'), findsOneWidget);

      await tester.tap(find.text('1Móz 1'));
      await tester.pumpAndSettle();
      expect(find.text('Ószövetség'), findsOneWidget); // the book picker, not Home

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('opened from the notes list: back to the book picker past the list', (tester) async {
      final server = FakeAnnotationApi()..savedElsewhere('55555555-5555-4555-8555-555555555555', 'BOOKMARK', 1);
      await pumpBible(tester, api: FakeBibleApi(), annotations: server);
      await tester.tap(find.byTooltip('Jelöléseim'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('1 Mózes 1:1'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3)); // the verse is lit up for two seconds

      await tester.tap(find.text('1Móz 1'));
      await tester.pumpAndSettle();
      expect(find.text('Ószövetség'), findsOneWidget);
      expect(find.text('Könyvjelzők'), findsNothing); // the list was left behind
    });
  });
}
