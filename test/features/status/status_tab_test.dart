import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/gender.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/router_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/status/providers/status_providers.dart';
import 'package:work_hu/features/streams/providers/streams_provider.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/user_status/data/repository/user_status_repository.dart';
import 'package:work_hu/features/user_status/providers/user_status_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

UserModel _user(num id, {bool member = true}) => UserModel(
  id: id,
  firstname: 'Teszt',
  lastname: 'Elek',
  role: Role.USER,
  changedPassword: true,
  gender: Gender.values.first,
  churchId: member ? 1 : null,
  permissions: [if (member) 'MEMBER_AREA'],
);

class TestUser extends ChangeNotifier implements UserProvider {
  TestUser({this.member = true});

  final bool member;

  @override
  UserModel? get user => _user(5, member: member);

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// The backend's user statuses: a status (a goal) for the ids in [withGoal], 404 for everybody else.
class FakeStatuses implements UserStatusRepository {
  FakeStatuses(this.withGoal);

  final Set<num> withGoal;
  final asked = <num>[];

  @override
  Future<UserStatusModel> getUserStatusByUserId(num userId, num seasonYear) async {
    asked.add(userId);
    if (!withGoal.contains(userId)) {
      final options = RequestOptions(path: '/userStatus/user/$userId');
      throw DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: 404),
      );
    }
    return UserStatusModel(
      id: 1,
      name: 'Teszt Elek',
      userId: userId,
      goal: 100000,
      status: 0.5,
      transactions: 50000,
      transition: 0,
      onTrack: true,
      localOnTrack: true,
      toOnTrack: 0,
      toLocalOnTrack: 0,
      seasonYear: seasonYear,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class FakeUsers implements UsersRepository {
  FakeUsers(this.children);

  final List<num> children;

  @override
  Future<List<UserModel>> getChildren(num id) async => [for (final c in children) _user(c)];

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<bool> _hasGoal({
  bool member = true,
  Set<num> withGoal = const {},
  List<num> children = const [],
  FakeStatuses? statuses,
}) {
  final container = ProviderContainer(
    overrides: [
      userDataProvider.overrideWith((ref) => TestUser(member: member)),
      userStatusRepoProvider.overrideWithValue(statuses ?? FakeStatuses(withGoal)),
      usersRepoProvider.overrideWithValue(FakeUsers(children)),
    ],
  );
  addTearDown(container.dispose);
  return container.read(hasStatusGoalProvider.future);
}

/// Whether the Status page has a goal to show, set by the test.
final _goal = StateProvider<bool?>((ref) => null);

Future<ProviderContainer> _pumpShell(WidgetTester tester) async {
  Widget page(String name) => Scaffold(body: Text(name));
  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => ScaffoldWithNestedNavigation(navigationShell: shell),
        branches: [
          for (final path in ['/home', '/status', '/balance', '/jobs', '/admin', '/live'])
            StatefulShellBranch(
              routes: [GoRoute(path: path, builder: (context, state) => page(path))],
            ),
        ],
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userDataProvider.overrideWith((ref) => TestUser()),
        liveStreamsProvider.overrideWith((ref) => Stream.value(const [])),
        // null = still asking: the answer never comes
        hasStatusGoalProvider.overrideWith((ref) {
          final goal = ref.watch(_goal);
          return goal == null ? Completer<bool>().future : Future.value(goal);
        }),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        builder: (context, child) => MaterialApp.router(routerConfig: router),
      ),
    ),
  );
  await tester.pump();
  return ProviderScope.containerOf(tester.element(find.byType(ScaffoldWithNestedNavigation)));
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    LocalJsonLocalization.delegate.directories = ['lib/I18n'];
    await LocalJsonLocalization.delegate.load(const Locale('hu', 'HU'));
  });

  group('hasStatusGoalProvider', () {
    test('a goal of their own', () async {
      expect(await _hasGoal(withGoal: {5}), isTrue);
    });

    test("a child's goal (the Status page shows the children too)", () async {
      expect(await _hasGoal(withGoal: {7}, children: [6, 7]), isTrue);
    });

    test('no goal for them or their children', () async {
      expect(await _hasGoal(children: [6]), isFalse);
    });

    test('non-members are not asked', () async {
      final statuses = FakeStatuses({5});
      expect(await _hasGoal(member: false, statuses: statuses), isFalse);
      expect(statuses.asked, isEmpty);
    });
  });

  group('Status tab', () {
    // translated only once the test runs (setUpAll loads the texts)
    Finder status() => find.text('nav_bar_status'.i18n());

    testWidgets('users without a goal have no Status tab', (tester) async {
      final container = await _pumpShell(tester);
      container.read(_goal.notifier).state = false;
      await tester.pump();
      await tester.pump();
      expect(find.text('nav_bar_start'.i18n()), findsOneWidget);
      expect(status(), findsNothing);

      // a goal set later (the provider is asked again on refresh or resume) brings the tab
      container.read(_goal.notifier).state = true;
      await tester.pump();
      await tester.pump();
      expect(status(), findsOneWidget);
    });

    testWidgets('hidden while still asking, there once a goal exists, kept while asking again', (tester) async {
      final container = await _pumpShell(tester);
      expect(status(), findsNothing);

      container.read(_goal.notifier).state = true;
      await tester.pump();
      await tester.pump();
      expect(status(), findsOneWidget);

      // asked again (e.g. pull to refresh): the last answer stays meanwhile
      container.read(_goal.notifier).state = null;
      await tester.pump();
      expect(status(), findsOneWidget);
    });
  });
}
