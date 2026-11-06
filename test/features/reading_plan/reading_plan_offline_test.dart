import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_hu/app/providers/locale_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/reading_plan/data/model/bible_translation.dart';
import 'package:work_hu/features/reading_plan/data/model/reading_plan_model.dart';
import 'package:work_hu/features/reading_plan/data/repository/reading_plan_repository.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart';
import 'package:work_hu/features/reading_plan/view/psalm_reader_page.dart';
import 'package:work_hu/features/reading_plan/view/psalms_page.dart';

import 'psalms_pages_test.dart' show FakeApi, FakeUserProvider;

/// The in-memory backend of the page tests that can be switched off ([offline]: no answer at all) or refuse marks.
class OfflineFakeApi extends FakeApi {
  bool offline = false;

  /// Answers marks with this status and a reason (e.g. 409: the plan closed meanwhile).
  int? refuseMarksWith;

  DioException get _noConnection => DioException(
    requestOptions: RequestOptions(path: '/reading-plan'),
    type: DioExceptionType.connectionError,
  );

  @override
  Future<Map<String, dynamic>?> getCurrent(String language) async {
    if (offline) throw _noConnection;
    return super.getCurrent(language);
  }

  @override
  Future<Map<String, dynamic>> mark(num planId, int item) async {
    if (offline) throw _noConnection;
    if (refuseMarksWith != null) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: refuseMarksWith,
          data: 'Closed.',
        ),
      );
    }
    return super.mark(planId, item);
  }

  @override
  Future<Map<String, dynamic>> unmark(num planId, int item) async {
    if (offline) throw _noConnection;
    return super.unmark(planId, item);
  }

  @override
  Future<List<dynamic>> getArticles(num planId, String language) async {
    if (offline) throw _noConnection;
    return super.getArticles(planId, language);
  }

  @override
  Future<Map<String, dynamic>> getLeaderboard(num planId, {int page = 0, int size = 100, String? group}) async {
    if (offline) throw _noConnection;
    return super.getLeaderboard(planId, page: page, size: size);
  }
}

/// A fresh start of the app (new providers, same device storage) with the plan loaded.
Future<ProviderContainer> start(OfflineFakeApi api) async {
  final container = ProviderContainer(
    overrides: [
      readingPlanRepoProvider.overrideWithValue(ReadingPlanRepository(api)),
      userDataProvider.overrideWith((ref) => FakeUserProvider()),
    ],
  );
  addTearDown(container.dispose);
  await container.read(localeProvider.future);
  container.listen(readingPlanProvider, (_, _) {});
  await container.read(readingPlanProvider.notifier).firstLoad;
  return container;
}

Future<Map<String, dynamic>> stored() async {
  final prefs = await SharedPreferences.getInstance();
  return {for (final k in prefs.getKeys()) k: prefs.get(k)};
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    LocalJsonLocalization.delegate.directories = ['lib/I18n'];
    await LocalJsonLocalization.delegate.load(const Locale('hu', 'HU'));
  });

  setUp(() => SharedPreferences.setMockInitialValues({'appLocale': 'hu'}));

  test('the plan seen online is shown offline after a restart, with the hint', () async {
    final api = OfflineFakeApi();
    var container = await start(api);
    expect(container.read(readingPlanProvider).plan!.myItems, {1, 2});
    expect(container.read(readingPlanProvider).offline, isFalse);
    container.dispose();

    api.offline = true;
    container = await start(api);
    final state = container.read(readingPlanProvider);
    expect(state.plan!.title, 'Zsoltárok olvasási terv');
    expect(state.plan!.myItems, {1, 2});
    expect(state.offline, isTrue);
    expect(state.error, isNull);
  });

  test('the copy is kept per user', () async {
    await start(OfflineFakeApi());
    expect((await stored()).keys, contains('reading_plan_5_current_hu'));
  });

  test('offline without any copy says so instead of an error', () async {
    final container = await start(OfflineFakeApi()..offline = true);
    final state = container.read(readingPlanProvider);
    expect(state.plan, isNull);
    expect(state.offline, isTrue);
    expect(state.error, "reading_plan_offline_none".i18n());
  });

  test('marks made offline stay, survive a restart and are sent when the server is back', () async {
    final api = OfflineFakeApi();
    var container = await start(api);
    api.offline = true;

    await container.read(readingPlanProvider.notifier).setRead(3, read: true);
    await container.read(readingPlanProvider.notifier).setRead(2, read: false);
    var state = container.read(readingPlanProvider);
    expect(state.plan!.myItems, {1, 3});
    expect(state.offline, isTrue);
    expect(state.unsent, 2);
    expect(api.items, {1, 2});
    expect(jsonDecode((await stored())['reading_plan_5_pending'] as String), {'1:3': true, '1:2': false});
    container.dispose();

    // Still offline at the next start: the copy shows the marks made here
    container = await start(api);
    expect(container.read(readingPlanProvider).plan!.myItems, {1, 3});
    expect(container.read(readingPlanProvider).unsent, 2);
    container.dispose();

    api.offline = false;
    container = await start(api);
    state = container.read(readingPlanProvider);
    expect(api.calls, ['mark 3', 'unmark 2']);
    expect(api.items, {1, 3});
    expect(state.plan!.myItems, {1, 3});
    expect(state.unsent, 0);
    expect(state.offline, isFalse);
    expect(jsonDecode((await stored())['reading_plan_5_pending'] as String), isEmpty);
  });

  test('a mark sent online updates the copy on the device', () async {
    final api = OfflineFakeApi();
    var container = await start(api);
    await container.read(readingPlanProvider.notifier).setRead(7, read: true);
    container.dispose();

    api.offline = true;
    container = await start(api);
    expect(container.read(readingPlanProvider).plan!.myItems, {1, 2, 7});
    expect(container.read(readingPlanProvider).unsent, 0);
  });

  test('a queued mark the server refuses is dropped, the server\'s items count', () async {
    final api = OfflineFakeApi();
    var container = await start(api);
    api.offline = true;
    await container.read(readingPlanProvider.notifier).setRead(3, read: true);
    container.dispose();

    api
      ..offline = false
      ..refuseMarksWith = 409;
    container = await start(api);
    final state = container.read(readingPlanProvider);
    expect(state.plan!.myItems, {1, 2});
    expect(state.unsent, 0);
  });

  test('articles and the ranking last seen are shown offline', () async {
    final api = OfflineFakeApi();
    var container = await start(api);
    final articles = await container.read(articlesProvider(1).future);
    final board = await container.read(leaderboardProvider(1).future);
    container.dispose();

    api.offline = true;
    container = await start(api);
    expect((await container.read(articlesProvider(1).future)).map((a) => a.title), articles.map((a) => a.title));
    expect((await container.read(leaderboardProvider(1).future)).entries.length, board.entries.length);
  });

  testWidgets('offline, the psalms open with a hint, a psalm is marked and sent later by itself', (tester) async {
    final api = OfflineFakeApi();
    // One online start keeps the copy
    final first = ProviderContainer(
      overrides: [
        readingPlanRepoProvider.overrideWithValue(ReadingPlanRepository(api)),
        userDataProvider.overrideWith((ref) => FakeUserProvider()),
      ],
    );
    await tester.runAsync(() async {
      await first.read(localeProvider.future);
      first.listen(readingPlanProvider, (_, _) {});
      await first.read(readingPlanProvider.notifier).firstLoad;
    });
    first.dispose();
    api.offline = true;

    final router = GoRouter(
      initialLocation: '/psalms/3',
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
      ],
    );
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          readingPlanRepoProvider.overrideWithValue(ReadingPlanRepository(api)),
          userDataProvider.overrideWith((ref) => FakeUserProvider()),
          activeTranslationProvider.overrideWithValue(bibleTranslations.first),
          psalmTextProvider.overrideWith(
            (ref, id) => {
              for (var i = 1; i <= 150; i++) i: [Verse(1, 'Vers $i')],
            },
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 640),
          builder: (context, child) => MaterialApp.router(routerConfig: router),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Vers 3'), findsOneWidget);
    expect(find.text("reading_plan_offline".i18n()), findsOneWidget);
    await tester.tap(find.text('Elolvastam'));
    await tester.pumpAndSettle();
    expect(find.text('Elolvasva – visszavonás'), findsOneWidget);
    expect(find.text("reading_plan_offline_unsent".i18n(['1'])), findsOneWidget);
    expect(api.calls, isEmpty);

    api.offline = false;
    await tester.pump(ReadingPlanNotifier.retryAfter);
    await tester.pumpAndSettle();
    expect(api.calls, ['mark 3']);
    expect(find.text("reading_plan_offline_unsent".i18n(['1'])), findsNothing);
    expect(find.text('Elolvasva – visszavonás'), findsOneWidget);
  });
}
