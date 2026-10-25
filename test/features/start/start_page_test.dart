import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/reading_plan/data/repository/reading_plan_repository.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart';
import 'package:work_hu/features/start/view/start_page.dart';
import 'package:work_hu/features/status/data/state/status_state.dart';
import 'package:work_hu/features/status/providers/status_providers.dart';
import 'package:work_hu/features/streams/providers/streams_provider.dart';
import 'package:work_hu/features/user_rounds/data/model/user_round_head_model.dart';

import '../reading_plan/psalms_pages_test.dart' show FakeApi;

class TestUser extends ChangeNotifier implements UserProvider {
  TestUser({required this.church});

  final bool church;

  @override
  UserModel? get user => UserModel(
    id: 5,
    firstname: 'André',
    lastname: 'Wagner',
    role: Role.USER,
    changedPassword: true,
    churchId: church ? 1 : null,
    permissions: const ['READING_PLAN'],
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// The Status page's data without the backend: the church's numbers this month.
class FakeStatus extends StateNotifier<StatusState> implements StatusDataNotifier {
  FakeStatus()
    : super(
        const StatusState(
          userRoundHead: UserRoundHeadModel(
            onTrackCount: 40,
            goalCount: 91,
            churchGoal: 80,
            toOnTrackCount: 35,
            localMyShareGoal: 100,
          ),
        ),
      );

  static var created = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

Future<List<String>> pumpStart(WidgetTester tester, {required bool church}) async {
  final opened = <String>[];
  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/home', builder: (context, state) => const StartPage()),
      GoRoute(
        path: '/bible',
        builder: (context, state) {
          opened.add('/bible');
          return const Scaffold(body: Text('Bible'));
        },
        routes: [
          GoRoute(
            path: ':book/:chapter',
            builder: (context, state) {
              opened.add(state.uri.toString());
              return const Scaffold(body: Text('Chapter'));
            },
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
        userDataProvider.overrideWith((ref) => TestUser(church: church)),
        readingPlanRepoProvider.overrideWithValue(ReadingPlanRepository(FakeApi())),
        liveStreamsProvider.overrideWith((ref) => Stream.value(const [])),
        statusDataProvider.overrideWith((ref) {
          FakeStatus.created++;
          return FakeStatus();
        }),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        builder: (context, child) => MaterialApp.router(routerConfig: router),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return opened;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    LocalJsonLocalization.delegate.directories = ['lib/I18n'];
    await LocalJsonLocalization.delegate.load(const Locale('hu', 'HU'));
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({'appLocale': 'hu'});
    FakeStatus.created = 0;
  });

  testWidgets('church members get the reading challenge, the church\'s status and the Bible', (tester) async {
    await pumpStart(tester, church: true);

    expect(find.text('Főoldal'), findsOneWidget);
    expect(find.text('AW'), findsOneWidget); // the profile button
    expect(find.text('Zsoltárok olvasási terv'), findsOneWidget);
    expect(find.text('Helyi státusz'), findsOneWidget);
    expect(find.text('40 fő'), findsOneWidget);
    expect(find.text('Biblia'), findsOneWidget);
  });

  testWidgets('users without a church only get the Bible, and their status is not asked for', (tester) async {
    final opened = await pumpStart(tester, church: false);

    expect(find.text('Biblia'), findsOneWidget);
    expect(find.text('Helyi státusz'), findsNothing);
    expect(find.text('Zsoltárok olvasási terv'), findsNothing);
    expect(FakeStatus.created, 0);

    await tester.tap(find.text('Biblia'));
    await tester.pumpAndSettle();
    expect(opened, ['/bible']);
  });

  testWidgets('the Bible card continues at the last chapter, by its remembered name', (tester) async {
    SharedPreferences.setMockInitialValues({
      'appLocale': 'hu',
      'bible_position': 'John.3',
      'bible_position_label': 'János 3',
    });
    final opened = await pumpStart(tester, church: false);

    expect(find.text('Folytatás: János 3'), findsOneWidget);
    await tester.tap(find.text('Folytatás: János 3'));
    await tester.pumpAndSettle();
    expect(opened, ['/bible/John/3']);
  });
}
