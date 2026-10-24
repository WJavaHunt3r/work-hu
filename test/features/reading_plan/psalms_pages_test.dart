import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' show FlutterQuillLocalizations, QuillEditor;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/reading_plan/data/api/reading_plan_api.dart';
import 'package:work_hu/features/reading_plan/data/model/bible_translation.dart';
import 'package:work_hu/features/reading_plan/data/model/reading_plan_model.dart';
import 'package:work_hu/features/reading_plan/data/repository/reading_plan_repository.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart';
import 'package:work_hu/features/reading_plan/view/article_edit_page.dart';
import 'package:work_hu/features/reading_plan/view/article_reader_page.dart';
import 'package:work_hu/features/reading_plan/view/psalm_reader_page.dart';
import 'package:work_hu/features/reading_plan/view/reading_plan_articles_admin_page.dart';
import 'package:work_hu/features/reading_plan/view/psalms_page.dart';
import 'package:work_hu/features/reading_plan/view/reading_plan_card.dart';

/// A backend in memory: the user starts with psalms 1 and 2 read.
class FakeApi implements ReadingPlanApi {
  final items = <int>{1, 2};
  final calls = <String>[];
  final languages = <String>[];
  bool open = true;
  bool hasPlan = true;
  final articleReads = <int>{2};
  final saved = <Map<String, dynamic>>[];
  final savedTranslations = <String>[];
  final requestedLanguages = <String>[];
  // English translations: article id -> title
  final english = <int, String>{2: 'Article 2 in English'};

  @override
  Future<Map<String, dynamic>?> getCurrent(String language) async {
    languages.add(language);
    return _plan(language);
  }

  Map<String, dynamic>? _plan(String language) => !hasPlan
      ? null
      : {
          'id': 1,
          'title': language == 'en' ? 'Psalms reading plan' : 'Zsoltárok olvasási terv',
          'bookKey': 'Ps',
          'itemCount': 150,
          'startDate': '2026-10-21',
          'endDate': '2026-11-13',
          'description': 'Közös kihívás',
          'open': open,
          'weeks': [
            {'weekNumber': 1, 'startItem': 1, 'endItem': 38, 'startsOn': '2026-10-21', 'endsOn': '2026-10-27'},
          ],
          'myItems': items.toList(),
          'participants': 2,
          'totalReadings': 9,
        };

  @override
  Future<Map<String, dynamic>> mark(num planId, int item) async {
    calls.add('mark $item');
    items.add(item);
    return {'myItems': items.toList()..sort()};
  }

  @override
  Future<Map<String, dynamic>> unmark(num planId, int item) async {
    calls.add('unmark $item');
    items.remove(item);
    return {'myItems': items.toList()..sort()};
  }

  Map<String, dynamic> _article(int id, {bool withBody = false, String language = 'hu', List<String>? languages}) {
    final translated = language == 'en' && english.containsKey(id);
    return {
      'id': id,
      'title': translated ? english[id] : 'Article $id',
      'points': 3,
      'read': articleReads.contains(id),
      'published': true,
      'createdDateTime': '2026-10-22T10:00:00',
      if (withBody) 'body': '[{"insert":"Text of article $id"},{"insert":"\\n"}]',
      'language': translated ? 'en' : 'hu',
      'languages': ?languages,
    };
  }

  @override
  Future<List<dynamic>> getArticles(num planId, String language) async {
    requestedLanguages.add(language);
    return [_article(2, language: language), _article(1, language: language)];
  }

  @override
  Future<Map<String, dynamic>> getArticle(num planId, num id, String language) async {
    requestedLanguages.add(language);
    return _article(id.toInt(), withBody: true, language: language);
  }

  @override
  Future<Map<String, dynamic>> markArticleRead(num planId, num id) async {
    calls.add('read article $id');
    articleReads.add(id.toInt());
    return _article(id.toInt());
  }

  @override
  Future<Map<String, dynamic>> unmarkArticleRead(num planId, num id) async {
    calls.add('unread article $id');
    articleReads.remove(id.toInt());
    return _article(id.toInt());
  }

  @override
  Future<List<dynamic>> getAllArticles(num planId) async => [
    _article(2),
    {..._article(1), 'published': false},
  ];

  @override
  Future<Map<String, dynamic>> getAnyArticle(num planId, num id) async =>
      _article(id.toInt(), withBody: true, languages: ['hu', if (english.containsKey(id.toInt())) 'en']);

  @override
  Future<Map<String, dynamic>> getArticleTranslation(num planId, num id, String language) async {
    if (language != 'en' || !english.containsKey(id.toInt())) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 404,
          data: 'There is no translation.',
        ),
      );
    }
    return _article(id.toInt(), withBody: true, language: 'en');
  }

  @override
  Future<Map<String, dynamic>> saveArticleTranslation(
    num planId,
    num id,
    String language,
    Map<String, dynamic> data,
  ) async {
    savedTranslations.add('$language ${data['title']}');
    return _article(id.toInt(), language: language);
  }

  @override
  Future<void> deleteArticleTranslation(num planId, num id, String language) async {}

  @override
  Future<Map<String, dynamic>> createArticle(num planId, Map<String, dynamic> data) async {
    saved.add(data);
    return _article(9);
  }

  @override
  Future<Map<String, dynamic>> updateArticle(num planId, num id, Map<String, dynamic> data) async =>
      _article(id.toInt());

  @override
  Future<void> deleteArticle(num planId, num id) async {}

  @override
  Future<Map<String, dynamic>> getLeaderboard(num planId, {int page = 0, int size = 100}) async => {
    'entries': [
      {'rank': 1, 'userId': 11, 'name': 'Kovács Éva', 'count': 12, 'articlePoints': 0},
      {'rank': 2, 'userId': 12, 'name': 'Nagy Béla', 'count': 6, 'articlePoints': 3},
    ],
    'total': 2,
    'page': 0,
    'size': 100,
    'myRank': 2,
    'myCount': 3,
    'myPoints': 6,
    'myArticlePoints': 3,
  };
}

/// Only [user] is read by the pages; everything else of the real provider needs the service locator.
class FakeUserProvider extends ChangeNotifier implements UserProvider {
  FakeUserProvider({this.permissions = const ['READING_PLAN']});

  final List<String> permissions;

  @override
  UserModel? get user => UserModel(
    id: 5,
    firstname: 'Test',
    lastname: 'User',
    role: Role.USER,
    changedPassword: true,
    permissions: permissions,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

Future<FakeApi> pumpPages(
  WidgetTester tester, {
  String location = '/psalms',
  bool open = true,
  bool followLanguage = false,
  List<String> permissions = const ['READING_PLAN'],
}) async {
  final api = FakeApi()..open = open;
  final router = GoRouter(
    initialLocation: location,
    routes: [
      GoRoute(
        path: '/psalms',
        builder: (context, state) => const PsalmsPage(),
        routes: [
          GoRoute(
            path: 'article/:id',
            builder: (context, state) => ArticleReaderPage(articleId: int.parse(state.pathParameters['id']!)),
          ),
          GoRoute(
            path: ':n',
            builder: (context, state) => PsalmReaderPage(number: int.parse(state.pathParameters['n']!)),
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
        readingPlanRepoProvider.overrideWithValue(ReadingPlanRepository(api)),
        userDataProvider.overrideWith((ref) => FakeUserProvider(permissions: permissions)),
        if (!followLanguage) activeTranslationProvider.overrideWithValue(bibleTranslations.first),
        // The real file is tested on its own; reading it needs real async IO, which the widget test clock doesn't run
        psalmTextProvider.overrideWith(
          (ref, id) => {
            for (var i = 1; i <= 150; i++) i: [Verse(1, 'Vers $i')],
          },
        ),
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
  return api;
}

void main() {
  // The real Hungarian texts, so the screens are laid out as in the app
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    LocalJsonLocalization.delegate.directories = ['lib/I18n'];
    await LocalJsonLocalization.delegate.load(const Locale('hu', 'HU'));
  });

  // Hungarian unless a test says otherwise (the test device itself is English)
  setUp(() => SharedPreferences.setMockInitialValues({'appLocale': 'hu'}));

  testWidgets('the grid shows all psalms, opens the reader on a tap and marks the psalm read', (tester) async {
    final api = await pumpPages(tester);

    expect(find.text('Zsoltárok olvasási terv'), findsOneWidget);
    expect(find.text('38'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsNWidgets(2)); // psalms 1 and 2 are read

    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();
    expect(find.text('Elolvastam'), findsOneWidget);
    expect(find.text('Vers 3'), findsOneWidget);

    await tester.tap(find.text('Elolvastam'));
    await tester.pumpAndSettle();
    expect(api.calls, ['mark 3']);
    expect(find.text('Elolvasva – visszavonás'), findsOneWidget);

    await tester.tap(find.text('Elolvasva – visszavonás'));
    await tester.pumpAndSettle();
    expect(api.calls, ['mark 3', 'unmark 3']);
    expect(find.text('Elolvastam'), findsOneWidget);
  });

  testWidgets('previous and next move through the psalms', (tester) async {
    await pumpPages(tester, location: '/psalms/5');

    expect(find.text('5. zsoltár'), findsOneWidget);
    await tester.tap(find.text('Következő'));
    await tester.pumpAndSettle();
    expect(find.text('6. zsoltár'), findsOneWidget);
    await tester.tap(find.text('Előző'));
    await tester.pumpAndSettle();
    expect(find.text('5. zsoltár'), findsOneWidget);
  });

  testWidgets('a closed plan cannot be changed', (tester) async {
    final api = await pumpPages(tester, location: '/psalms/5', open: false);

    final button = tester.widget<FilledButton>(find.byWidgetPredicate((w) => w is FilledButton));
    expect(button.onPressed, isNull);
    expect(find.text('A kihívás nem aktív, ezért a jelölés nem módosítható.'), findsOneWidget);
    expect(api.calls, isEmpty);
  });

  testWidgets('the ranking tab lists the people with their ranks and my place', (tester) async {
    await pumpPages(tester);

    await tester.tap(find.text('Ranglista'));
    await tester.pumpAndSettle();

    expect(find.text('Kovács Éva'), findsOneWidget);
    expect(find.text('Nagy Béla'), findsOneWidget);
    expect(find.text('Zsoltárok: 3 · Cikkek: 3 pont'), findsOneWidget);
    expect(find.text('Te a(z) 2. helyen állsz, 6 ponttal'), findsOneWidget);
  });

  testWidgets('the Status page card shows the progress', (tester) async {
    final api = FakeApi();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          readingPlanRepoProvider.overrideWithValue(ReadingPlanRepository(api)),
          userDataProvider.overrideWith((ref) => FakeUserProvider()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 640),
          builder: (context, child) => const MaterialApp(home: Scaffold(body: ReadingPlanCard())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Zsoltárok olvasási terv'), findsOneWidget);
    expect(find.text('1%'), findsOneWidget); // 2 of 150
    expect(find.text('2 / 150 elolvasva'), findsOneWidget);
    expect(find.text('1. időszak: 2/38'), findsOneWidget);
  });

  testWidgets('the Status page card is not there when there is no plan', (tester) async {
    final api = FakeApi()..hasPlan = false;
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          readingPlanRepoProvider.overrideWithValue(ReadingPlanRepository(api)),
          userDataProvider.overrideWith((ref) => FakeUserProvider()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 640),
          builder: (context, child) => const MaterialApp(home: Scaffold(body: ReadingPlanCard())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNothing);
    expect(find.text('Zsoltárok olvasási terv'), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('the translation follows the app language until the user picks one, and the pick is remembered', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'appLocale': 'en'});
    await pumpPages(tester, location: '/psalms/5', followLanguage: true);

    expect(find.text('WEB'), findsOneWidget); // English app, so the English default
    expect(find.text('World English Bible (public domain)'), findsOneWidget);

    await tester.tap(find.text('WEB'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('King James Version (1769, public domain)'));
    await tester.pumpAndSettle();

    expect(find.text('KJV'), findsOneWidget);
    expect(find.text('King James Version (1769, public domain)'), findsOneWidget);
    expect((await SharedPreferences.getInstance()).getString('bible_translation'), 'kjv');
  });

  testWidgets('without the READING_PLAN permission nothing is requested and the card is not there', (tester) async {
    final api = FakeApi();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          readingPlanRepoProvider.overrideWithValue(ReadingPlanRepository(api)),
          userDataProvider.overrideWith((ref) => FakeUserProvider(permissions: const ['JOB_CREATE'])),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 640),
          builder: (context, child) => const MaterialApp(home: Scaffold(body: ReadingPlanCard())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Zsoltárok olvasási terv'), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(api.languages, isEmpty);
  });

  testWidgets('the plan is asked for in the app language', (tester) async {
    SharedPreferences.setMockInitialValues({'appLocale': 'en'});
    final api = FakeApi();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          readingPlanRepoProvider.overrideWithValue(ReadingPlanRepository(api)),
          userDataProvider.overrideWith((ref) => FakeUserProvider()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 640),
          builder: (context, child) => const MaterialApp(home: Scaffold(body: ReadingPlanCard())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(api.languages.last, 'en');
    expect(find.text('Psalms reading plan'), findsOneWidget);
    expect(find.text('Zsoltárok olvasási terv'), findsNothing);
  });

  testWidgets('the articles tab lists the published articles and the reader marks one as read for its points', (
    tester,
  ) async {
    final api = await pumpPages(tester);

    await tester.tap(find.text('Cikkek'));
    await tester.pumpAndSettle();
    expect(find.text('Article 2'), findsOneWidget);
    expect(find.text('Article 1'), findsOneWidget);
    expect(find.text('+3 pont'), findsNWidgets(2));
    expect(find.byIcon(Icons.check_circle), findsOneWidget); // article 2 is read

    await tester.tap(find.text('Article 1'));
    await tester.pumpAndSettle();
    expect(find.byType(QuillEditor), findsOneWidget); // the text itself is drawn by the editor
    expect(find.text('Elolvastam (+3 pont)'), findsOneWidget);

    await tester.tap(find.text('Elolvastam (+3 pont)'));
    await tester.pumpAndSettle();
    expect(api.calls, ['read article 1']);
    expect(find.text('Elolvasva – visszavonás'), findsOneWidget);

    await tester.tap(find.text('Elolvasva – visszavonás'));
    await tester.pumpAndSettle();
    expect(api.calls, ['read article 1', 'unread article 1']);
  });

  testWidgets('an article cannot be marked after the challenge', (tester) async {
    final api = await pumpPages(tester, location: '/psalms/article/1', open: false);

    final button = tester.widget<FilledButton>(find.byWidgetPredicate((w) => w is FilledButton));
    expect(button.onPressed, isNull);
    expect(api.calls, isEmpty);
  });

  testWidgets('the admin list shows the articles with their drafts', (tester) async {
    final api = FakeApi();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          readingPlanRepoProvider.overrideWithValue(ReadingPlanRepository(api)),
          userDataProvider.overrideWith((ref) => FakeUserProvider(permissions: const ['READING_PLAN_MANAGE'])),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 640),
          builder: (context, child) => const MaterialApp(home: ReadingPlanArticlesAdminPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Article 2'), findsOneWidget);
    expect(find.text('Article 1'), findsOneWidget);
    expect(find.text('Piszkozat'), findsOneWidget); // only article 1 is a draft
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('a manager can save a new draft article from the editor', (tester) async {
    final api = FakeApi();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          readingPlanRepoProvider.overrideWithValue(ReadingPlanRepository(api)),
          userDataProvider.overrideWith((ref) => FakeUserProvider(permissions: const ['READING_PLAN_MANAGE'])),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 640),
          builder: (context, child) => MaterialApp(
            localizationsDelegates: FlutterQuillLocalizations.localizationsDelegates,
            home: const ArticleEditPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Cím'), 'My article');
    await tester.enterText(find.widgetWithText(TextField, 'Pont'), '5');
    await tester.tap(find.text('Mentés'));
    await tester.pumpAndSettle();

    expect(api.saved, hasLength(1));
    expect(api.saved.single['title'], 'My article');
    expect(api.saved.single['points'], 5);
    expect(api.saved.single['published'], false);
    expect(api.saved.single['body'], isNull); // nothing written yet
  });

  testWidgets('in an English app the articles come with their English titles, others stay Hungarian with a note', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'appLocale': 'en'});
    final api = await pumpPages(tester, followLanguage: true);

    await tester.tap(find.text('Cikkek')); // the labels stay Hungarian here: only the language setting is English
    await tester.pumpAndSettle();

    expect(api.requestedLanguages, everyElement('en'));
    expect(find.text('Article 2 in English'), findsOneWidget); // translated
    expect(find.text('Article 1'), findsOneWidget); // no translation: the default text

    await tester.tap(find.text('Article 1'));
    await tester.pumpAndSettle();
    expect(find.text('Ez a cikk még nem érhető el a te nyelveden, ezért magyarul olvasható.'), findsOneWidget);
  });

  testWidgets('a translated article shows without the language note', (tester) async {
    SharedPreferences.setMockInitialValues({'appLocale': 'en'});
    await pumpPages(tester, location: '/psalms/article/2', followLanguage: true);

    expect(find.text('Article 2 in English'), findsOneWidget); // the translated title heads the text
    expect(find.text('Ez a cikk még nem érhető el a te nyelveden, ezért magyarul olvasható.'), findsNothing);
  });

  Future<FakeApi> pumpEditor(WidgetTester tester, {num? id}) async {
    final api = FakeApi();
    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          readingPlanRepoProvider.overrideWithValue(ReadingPlanRepository(api)),
          userDataProvider.overrideWith((ref) => FakeUserProvider(permissions: const ['READING_PLAN_MANAGE'])),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 640),
          builder: (context, child) => MaterialApp(
            localizationsDelegates: FlutterQuillLocalizations.localizationsDelegates,
            home: ArticleEditPage(id: id),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return api;
  }

  testWidgets('a new article can only be written in Hungarian until it is saved', (tester) async {
    await pumpEditor(tester);

    expect(find.text('A fordításokhoz előbb mentsd el a magyar változatot.'), findsOneWidget);
    final english = tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'English'));
    expect(english.onSelected, isNull);
    final hungarian = tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Magyar'));
    expect(hungarian.onSelected, isNotNull);
  });

  testWidgets('the editor switches language, loads the saved translation and saves it as a translation', (
    tester,
  ) async {
    final api = await pumpEditor(tester, id: 2);

    expect(find.widgetWithText(TextField, 'Article 2'), findsOneWidget); // the Hungarian text
    expect(find.text('Közzétéve'), findsOneWidget); // points and publishing are the article's

    await tester.tap(find.widgetWithText(ChoiceChip, 'English'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Article 2 in English'), findsOneWidget);
    expect(find.text('Közzétéve'), findsNothing); // not for a translation

    await tester.enterText(find.widgetWithText(TextField, 'Article 2 in English'), 'Better title');
    await tester.tap(find.text('Mentés'));
    await tester.pumpAndSettle();
    expect(api.savedTranslations, ['en Better title']);
    expect(api.saved, isEmpty); // the article itself was not touched

    // Back to Hungarian: its own text was kept, and German has no translation yet
    await tester.tap(find.widgetWithText(ChoiceChip, 'Magyar'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Article 2'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Deutsch'));
    await tester.pumpAndSettle();
    expect(find.text('Ehhez a nyelvhez még nincs fordítás. Írd meg, és mentsd el.'), findsOneWidget);
  });

  testWidgets('a translation needs a title', (tester) async {
    final api = await pumpEditor(tester, id: 2);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Deutsch'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mentés'));
    await tester.pumpAndSettle();

    expect(api.savedTranslations, isEmpty);
  });
}
