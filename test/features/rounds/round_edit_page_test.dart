import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/features/rounds/data/api/round_api.dart';
import 'package:work_hu/features/rounds/data/model/round_filter.dart';
import 'package:work_hu/features/rounds/data/repository/round_repository.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/rounds/view/round_edit_page.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';
import 'package:work_hu/features/season/provider/seasons_list_provider.dart';

class _FakeRoundApi implements RoundApi {
  _FakeRoundApi({this.status = 72.2});

  final double? status;
  final sent = <Map<String, dynamic>>[];

  Map<String, dynamic> get round => {
    'id': 5,
    'startDateTime': '2026-10-01T00:00:00',
    'endDateTime': '2026-10-31T23:59:00',
    'myShareGoal': 110.0,
    'localMyShareGoal': 110.0,
    'samvirkGoal': 0,
    'samvirkChurchGoal': 0,
    'roundNumber': 10,
    'freezeDateTime': '2026-10-30T23:59:00',
    'activeRound': true,
    'samvirkChurchStatus': status,
    'season': {'id': 1, 'seasonYear': 2026},
  };

  @override
  Future<dynamic> getRound(num? roundId) async => round;

  @override
  Future<dynamic> putRound(num roundId, Map<String, dynamic> data) async {
    sent.add(data);
    return round;
  }

  @override
  Future<dynamic> postRound(Map<String, dynamic> data) async {
    sent.add(data);
    return round;
  }

  @override
  Future<dynamic> getRounds(ListQuery<RoundFilter> query, int page) async => {};

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    LocalJsonLocalization.delegate.directories = ['lib/I18n'];
    await LocalJsonLocalization.delegate.load(const Locale('hu', 'HU'));
  });

  Future<_FakeRoundApi> pumpEditor(WidgetTester tester, {double? status = 72.2, int? roundId = 5}) async {
    final api = _FakeRoundApi(status: status);
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SizedBox()),
        GoRoute(
          path: '/edit',
          builder: (context, state) => RoundEditPage(id: roundId),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          roundRepoProvider.overrideWithValue(RoundRepository(api)),
          seasonsListProvider.overrideWith((ref) async => [const SeasonModel(id: 1, seasonYear: 2026)]),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 640),
          builder: (context, child) => MaterialApp.router(routerConfig: router),
        ),
      ),
    );
    router.push('/edit');
    await tester.pumpAndSettle();
    return api;
  }

  Finder statusField() => find.widgetWithText(TextFormField, '72.2');

  testWidgets('the form shows the stored Samvirk church status', (tester) async {
    await pumpEditor(tester);

    expect(find.text('Samvirk gyülekezeti státusz (%)'), findsOneWidget);
    expect(statusField(), findsOneWidget);
  });

  testWidgets('a changed status is sent with the rest of the round (a comma counts as the decimal point)', (
    tester,
  ) async {
    final api = await pumpEditor(tester);

    await tester.enterText(statusField(), '81,5');
    await tester.tap(find.text('Mentés'));
    await tester.pumpAndSettle();

    expect(api.sent, hasLength(1));
    expect(api.sent.single['samvirkChurchStatus'], 81.5);
    expect(api.sent.single['roundNumber'], 10); // the other fields are still sent
  });

  testWidgets('an empty status is sent as null, which leaves the stored one as it is', (tester) async {
    final api = await pumpEditor(tester);

    await tester.enterText(statusField(), '');
    await tester.tap(find.text('Mentés'));
    await tester.pumpAndSettle();

    expect(api.sent.single['samvirkChurchStatus'], isNull);
  });

  testWidgets('zero is a real value and is sent', (tester) async {
    final api = await pumpEditor(tester);

    await tester.enterText(statusField(), '0');
    await tester.tap(find.text('Mentés'));
    await tester.pumpAndSettle();

    expect(api.sent.single['samvirkChurchStatus'], 0);
  });

  testWidgets('text that is not a number is not saved', (tester) async {
    final api = await pumpEditor(tester);

    await tester.enterText(statusField(), 'abc');
    await tester.tap(find.text('Mentés'));
    await tester.pumpAndSettle();

    expect(api.sent, isEmpty);
    expect(find.text('Adj meg egy számot (0 vagy több)'), findsOneWidget);
  });

  testWidgets('an old round without a stored status shows an empty field', (tester) async {
    await pumpEditor(tester, status: null);

    expect(find.text('72.2'), findsNothing);
    expect(find.text('Samvirk gyülekezeti státusz (%)'), findsOneWidget);
  });
}
