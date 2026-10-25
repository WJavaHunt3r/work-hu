import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' show FlutterQuillLocalizations;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/bible/data/model/bible_model.dart' show parseVerseRange;
import 'package:work_hu/features/bible/providers/bible_annotations_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/reading_plan/data/api/public_note_api.dart';
import 'package:work_hu/features/reading_plan/data/model/bible_translation.dart';
import 'package:work_hu/features/reading_plan/data/model/reading_plan_model.dart';
import 'package:work_hu/features/reading_plan/data/repository/reading_plan_repository.dart';
import 'package:work_hu/features/reading_plan/providers/public_notes_provider.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart';
import 'package:work_hu/features/reading_plan/view/psalm_reader_page.dart';
import 'package:work_hu/features/reading_plan/view/psalms_page.dart';
import 'package:work_hu/features/reading_plan/view/reported_notes_page.dart';

import '../bible/bible_test.dart' show FakeAnnotationApi;
import 'psalms_pages_test.dart' show FakeApi;

class TestUser extends ChangeNotifier implements UserProvider {
  TestUser({this.church = true, this.manager = false});

  final bool church;
  final bool manager;

  @override
  UserModel? get user => UserModel(
    id: 5,
    firstname: 'Anna',
    lastname: 'Kovács',
    role: Role.USER,
    changedPassword: true,
    churchId: church ? 1 : null,
    permissions: ['READING_PLAN', if (manager) 'READING_PLAN_MANAGE'],
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// The public notes backend in memory, with its visibility rules.
class FakePublicNoteApi implements PublicNoteApi {
  FakePublicNoteApi({required this.me, this.manager = false});

  final int me;
  final bool manager;
  final calls = <String>[];
  final notes = <Map<String, dynamic>>[];
  final reports = <num, List<String?>>{};
  var _id = 100;

  void add({
    required int item,
    required int verse,
    required String author,
    required int authorId,
    bool hidden = false,
  }) => notes.add({
    'id': ++_id,
    'item': item,
    'verseStart': verse,
    'verseEnd': verse,
    'translation': 'kar',
    'numbering': 'kjv',
    'text': 'Jegyzet $_id',
    'author': author,
    'authorId': authorId,
    'hidden': hidden,
  });

  Map<String, dynamic> _out(Map<String, dynamic> n) => {
    ...n,
    'mine': n['authorId'] == me,
    'reportedByMe': reports[n['id']]?.isNotEmpty == true && reportedByMe.contains(n['id']),
    'hidden': (manager || n['authorId'] == me) && n['hidden'] == true,
    'reportCount': manager ? (reports[n['id']]?.length ?? 0) : null,
  };

  final reportedByMe = <num>{};

  @override
  Future<List<dynamic>> getForItem(num planId, int item) async {
    calls.add('get $item');
    return [
      for (final n in notes)
        if (n['item'] == item && (manager || n['hidden'] != true || n['authorId'] == me)) _out(n),
    ];
  }

  @override
  Future<Map<String, dynamic>> getCounts(num planId) async {
    calls.add('counts');
    final counts = <String, dynamic>{};
    for (final n in notes.where((n) => n['hidden'] != true)) {
      counts['${n['item']}'] = (counts['${n['item']}'] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Future<Map<String, dynamic>> create(num planId, Map<String, dynamic> note) async {
    calls.add(
      'create ${note['item']}:${note['verseStart']}-${note['verseEnd']} ${note['translation']}/${note['numbering']}',
    );
    final n = {...note, 'id': ++_id, 'author': 'Kovács Anna', 'authorId': me, 'hidden': false};
    notes.add(n);
    return _out(n);
  }

  @override
  Future<Map<String, dynamic>> update(num planId, num id, String text) async {
    calls.add('update $id');
    final n = notes.firstWhere((n) => n['id'] == id)..['text'] = text;
    return _out(n);
  }

  @override
  Future<void> delete(num planId, num id) async {
    calls.add('delete $id');
    notes.removeWhere((n) => n['id'] == id);
  }

  @override
  Future<void> report(num planId, num id, String? reason) async {
    calls.add('report $id ${reason ?? '-'}');
    reports.putIfAbsent(id, () => []).add(reason);
    reportedByMe.add(id);
  }

  @override
  Future<List<dynamic>> getReported(num planId) async => [
    for (final n in notes)
      if (reports[n['id']]?.isNotEmpty == true)
        {
          'note': _out(n),
          'reports': [
            for (final r in reports[n['id']]!) {'reason': r},
          ],
        },
  ];

  @override
  Future<void> setHidden(num planId, num id, bool hidden) async {
    calls.add('hidden $id $hidden');
    notes.firstWhere((n) => n['id'] == id)['hidden'] = hidden;
  }
}

/// Refuses everything as a closed plan would.
class ClosedPublicNoteApi extends FakePublicNoteApi {
  ClosedPublicNoteApi() : super(me: 5);

  @override
  Future<Map<String, dynamic>> create(num planId, Map<String, dynamic> note) async => throw DioException(
    requestOptions: RequestOptions(path: '/x'),
    response: Response(
      requestOptions: RequestOptions(path: '/x'),
      statusCode: 409,
      data: 'The reading plan is not open',
    ),
    type: DioExceptionType.badResponse,
  );
}

Future<void> pump(
  WidgetTester tester, {
  required FakePublicNoteApi notes,
  TestUser? user,
  String location = '/psalms/23',
  FakeAnnotationApi? annotations,
}) async {
  final router = GoRouter(
    initialLocation: location,
    routes: [
      GoRoute(
        path: '/psalms',
        builder: (context, state) => const PsalmsPage(),
        routes: [
          GoRoute(
            path: ':n',
            builder: (context, state) => PsalmReaderPage(number: int.parse(state.pathParameters['n']!)),
          ),
        ],
      ),
      GoRoute(path: '/admin/readingPlan/reported', builder: (context, state) => const ReportedNotesPage()),
    ],
  );
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        readingPlanRepoProvider.overrideWithValue(ReadingPlanRepository(FakeApi())),
        userDataProvider.overrideWith((ref) => user ?? TestUser()),
        activeTranslationProvider.overrideWithValue(bibleTranslations.first),
        psalmTextProvider.overrideWith(
          (ref, id) => {
            for (var i = 1; i <= 150; i++) i: [Verse(1, 'Első vers $i'), Verse(2, 'Második vers $i')],
          },
        ),
        publicNoteApiProvider.overrideWithValue(notes),
        bibleAnnotationApiProvider.overrideWithValue(annotations ?? FakeAnnotationApi()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        builder: (context, child) => MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: FlutterQuillLocalizations.localizationsDelegates,
        ),
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

  test('psalm numbering: Károli and Norsk count titles as verses', () {
    expect(psalmNumbering('kar', 3), 'heb');
    expect(psalmNumbering('nb1930', 51), 'heb');
    expect(psalmNumbering('kar', 1), 'kjv');
    expect(psalmNumbering('kjv', 3), 'kjv');
    expect(psalmNumbering('luth1912', 3), 'kjv');
  });

  test('a link\'s verses are one verse or a range', () {
    expect(parseVerseRange('16'), (start: 16, end: 16));
    expect(parseVerseRange('16-18'), (start: 16, end: 18));
    expect(parseVerseRange('18-16'), isNull);
    expect(parseVerseRange('x'), isNull);
    expect(parseVerseRange(null), isNull);
  });

  testWidgets('members read the shared notes and write one on the selected verses', (tester) async {
    final api = FakePublicNoteApi(me: 5)..add(item: 23, verse: 1, author: 'Nagy Béla', authorId: 9);
    await pump(tester, notes: api);

    expect(find.text('Közös jegyzetek (1)'), findsOneWidget);
    expect(find.textContaining('Nagy Béla'), findsOneWidget);
    expect(find.text('Jegyzet 101'), findsOneWidget);

    await tester.tap(find.text('Második vers 23'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Közös'));
    await tester.pumpAndSettle();
    expect(find.textContaining('a neveddel együtt'), findsOneWidget); // who will see it
    await tester.enterText(find.byType(TextField), 'Az Úr az én pásztorom');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mentés'));
    await tester.pumpAndSettle();

    expect(api.calls, contains('create 23:2-2 kar/kjv'));
    expect(find.text('Közös jegyzetek (2)'), findsOneWidget);
    expect(find.text('Az Úr az én pásztorom'), findsOneWidget);
  });

  testWidgets('the author edits and deletes their own note; others\' notes can be reported once', (tester) async {
    final api = FakePublicNoteApi(me: 5)
      ..add(item: 23, verse: 1, author: 'Kovács Anna', authorId: 5)
      ..add(item: 23, verse: 2, author: 'Nagy Béla', authorId: 9);
    await pump(tester, notes: api);

    // mine: edit and delete, no report
    await tester.tap(find.byIcon(Icons.more_vert).first);
    await tester.pumpAndSettle();
    expect(find.text('Szerkesztés'), findsOneWidget);
    expect(find.text('Jelentés'), findsNothing);
    await tester.tap(find.text('Szerkesztés'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Javított');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mentés'));
    await tester.pumpAndSettle();
    expect(find.text('Javított'), findsOneWidget);

    // theirs: report with a reason
    await tester.tap(find.byIcon(Icons.more_vert).last);
    await tester.pumpAndSettle();
    expect(find.text('Szerkesztés'), findsNothing);
    expect(find.text('Törlés'), findsNothing);
    await tester.tap(find.text('Jelentés'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'nem ide való');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Jelentés'));
    await tester.pumpAndSettle();
    expect(api.calls, contains('report 102 nem ide való'));
    expect(find.text('Köszönjük, a jegyzetet jelentetted.'), findsOneWidget);
    // reported: nothing left to do with it
    expect(find.byIcon(Icons.more_vert), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Törlés'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Törlés'));
    await tester.pumpAndSettle();
    expect(api.calls, contains('delete 101'));
    expect(find.text('Közös jegyzetek (1)'), findsOneWidget);
  });

  testWidgets('users without a church see no shared notes and nothing is asked for', (tester) async {
    final api = FakePublicNoteApi(me: 5)..add(item: 23, verse: 1, author: 'Nagy Béla', authorId: 9);
    await pump(tester, notes: api, user: TestUser(church: false));

    expect(find.textContaining('Közös jegyzetek'), findsNothing);
    await tester.tap(find.text('Első vers 23'));
    await tester.pumpAndSettle();
    expect(find.text('Közös'), findsNothing); // the selection bar has no shared note
    expect(find.text('Link'), findsOneWidget);
    expect(api.calls, isEmpty);
  });

  testWidgets('managers see hidden notes and report counts, hide and delete; the reported list', (tester) async {
    final api = FakePublicNoteApi(me: 7, manager: true)
      ..add(item: 23, verse: 1, author: 'Nagy Béla', authorId: 9)
      ..add(item: 23, verse: 2, author: 'Tóth Dóra', authorId: 8, hidden: true);
    api.reports[101] = ['sértő', null];
    await pump(tester, notes: api, user: TestUser(church: false, manager: true));

    expect(find.text('Elrejtve'), findsOneWidget);
    expect(find.text('2 jelentés'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.more_vert).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Elrejtés'));
    await tester.pumpAndSettle();
    expect(api.calls, contains('hidden 101 true'));
    expect(find.text('Elrejtve'), findsNWidgets(2));

    GoRouter.of(tester.element(find.byType(PsalmReaderPage))).go('/admin/readingPlan/reported');
    await tester.pumpAndSettle();
    expect(find.textContaining('Nagy Béla'), findsOneWidget);
    expect(find.text('• sértő'), findsOneWidget);
    expect(find.text('• (nincs megadva ok)'), findsOneWidget);
    await tester.tap(find.text('Törlés'));
    await tester.pumpAndSettle();
    expect(api.calls, contains('delete 101'));
    expect(find.text('Nincs jelentett közös jegyzet.'), findsOneWidget);
  });

  testWidgets('a refused note (the plan closed) shows the server\'s reason', (tester) async {
    await pump(tester, notes: ClosedPublicNoteApi());

    await tester.tap(find.text('Első vers 23'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Közös'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Késő');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mentés'));
    await tester.pumpAndSettle();
    expect(find.text('Közös jegyzetek (0)'), findsOneWidget);
  });

  testWidgets('psalm highlights are the Bible\'s, with the psalm\'s numbering, and the link opens the Bible', (
    tester,
  ) async {
    final annotations = FakeAnnotationApi();
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') copied = (call.arguments as Map)['text'] as String;
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
    await pump(tester, notes: FakePublicNoteApi(me: 5), location: '/psalms/3', annotations: annotations);

    await tester.tap(find.text('Első vers 3'));
    await tester.tap(find.text('Második vers 3'));
    await tester.pumpAndSettle();
    expect(find.text('Zsolt 3:1-2'), findsOneWidget);
    await tester.tap(find.text('Link'));
    await tester.pumpAndSettle();
    expect(copied, 'Zsoltárok 3:1-2\nhttps://dukapp.bcc-ktk.org/bible/Ps/3?verse=1-2');

    await tester.tap(find.text('Első vers 3'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('yellow'));
    await tester.pumpAndSettle();
    final saved = annotations.rows.values.single;
    expect([saved['book'], saved['chapter'], saved['verseStart'], saved['numbering']], ['Ps', 3, 1, 'heb']);
  });

  testWidgets('the psalm grid shows how many shared notes a psalm has', (tester) async {
    final api = FakePublicNoteApi(me: 5)
      ..add(item: 23, verse: 1, author: 'Nagy Béla', authorId: 9)
      ..add(item: 23, verse: 2, author: 'Tóth Dóra', authorId: 8)
      ..add(item: 1, verse: 1, author: 'Tóth Dóra', authorId: 8, hidden: true);
    await pump(tester, notes: api, location: '/psalms');

    expect(find.byIcon(Icons.forum), findsOneWidget); // psalm 23 only: the hidden one doesn't count
  });
}
