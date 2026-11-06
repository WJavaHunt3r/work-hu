import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_hu/app/cache/user_data_cache.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe/data/model/sumup_user_model.dart';
import 'package:work_hu/features/bufe/data/repository/bufe_repository.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/donation/data/repository/donation_repository.dart';
import 'package:work_hu/features/goal/data/repository/goal_repository.dart';
import 'package:work_hu/features/home/providers/home_provider.dart';
import 'package:work_hu/features/jobs/data/model/job_enums.dart';
import 'package:work_hu/features/jobs/data/model/job_filter.dart';
import 'package:work_hu/features/jobs/data/model/job_model.dart';
import 'package:work_hu/features/jobs/data/repository/job_repository.dart';
import 'package:work_hu/features/jobs/providers/jobs_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/status/providers/status_providers.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_items_filter.dart';
import 'package:work_hu/features/transaction_items/data/repository/transaction_items_repository.dart';
import 'package:work_hu/features/user_rounds/data/model/user_round_head_model.dart';
import 'package:work_hu/features/user_rounds/data/repository/user_round_repository.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/user_status/data/repository/user_status_repository.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';

const me = UserModel(id: 5, firstname: 'André', lastname: 'Wagner', role: Role.USER, changedPassword: true);

class TestUser extends ChangeNotifier implements UserProvider {
  @override
  UserModel? get user => me;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

DioException offline() => DioException.connectionError(
  requestOptions: RequestOptions(path: '/'),
  reason: 'offline',
);

/// The backend's answer for each call: a completer per call, so a test decides when (and whether) it answers.
class Answers {
  final _calls = <String, Completer<Object>>{};

  Completer<Object> of(String call) => _calls.putIfAbsent(call, Completer.new);

  Future<T> get<T>(String call) async => await of(call).future as T;

  void answer(String call, Object value) => of(call).complete(value);

  void failAll() {
    for (final c in _calls.values) {
      if (!c.isCompleted) c.completeError(offline());
    }
  }
}

UserStatusModel status(num userId, {num status = 0.5}) => UserStatusModel(
  id: userId,
  name: 'User $userId',
  userId: userId,
  goal: 1000,
  status: status,
  transactions: 500,
  transition: 0,
  onTrack: true,
  localOnTrack: true,
  toOnTrack: 0,
  toLocalOnTrack: 0,
  seasonYear: 2026,
);

const head = UserRoundHeadModel(
  onTrackCount: 40,
  goalCount: 91,
  churchGoal: 80,
  localMyShareGoal: 100,
  toOnTrackCount: 35,
);

class FakeStatuses implements UserStatusRepository {
  FakeStatuses(this.answers);

  final Answers answers;

  @override
  Future<UserStatusModel> getUserStatusByUserId(num userStatusId, num seasonYear) =>
      answers.get('status $userStatusId');

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeRounds implements UserRoundRepository {
  FakeRounds(this.answers);

  final Answers answers;

  @override
  Future<UserRoundHeadModel> getHeadData() => answers.get('head');

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeUsers implements UsersRepository {
  FakeUsers(this.answers);

  final Answers answers;

  @override
  Future<List<UserModel>> getChildren(num id) => answers.get('children');

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeTransactionItems implements TransactionItemsRepository {
  FakeTransactionItems(this.answers);

  final Answers answers;

  @override
  Future<PaginatedResponse<TransactionItemModel>> getTransactionItems(
    ListQuery<TransactionItemsFilter> query, {
    int page = 0,
  }) => answers.get('transactions');

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeGoals implements GoalRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeBufe implements BufeRepository {
  FakeBufe(this.answers);

  final Answers answers;

  @override
  Future<SumupUserModel> getAccount(num userId) => answers.get('account $userId');

  @override
  Future<Order> getOrders({required num userId, int limit = 50, int page = 0}) => answers.get('orders');

  @override
  Future<List<DukappImages>> getDukappImages() => answers.get('images');

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeDonations implements DonationRepository {
  @override
  Future<List<DonationModel>> getDonations(DateTime? dateTime) async => [];

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeJobs implements JobRepository {
  FakeJobs(this.answers);

  final Answers answers;
  final queries = <ListQuery<JobFilter>>[];

  @override
  Future<PaginatedResponse<JobModel>> getJobs(ListQuery<JobFilter> query, {int page = 0, num? registeredUserId}) {
    queries.add(query);
    return answers.get('jobs ${queries.length}');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

SumupUserModel account(num balance) =>
    SumupUserModel(full_name: 'Wagner André', balance: balance, dukapp_id: '5', spent: 0);

JobModel job(num id, String description) => JobModel(
  id: id,
  jobDateTime: DateTime(2026, 11, 2, 17),
  description: description,
  employerId: 1,
  responsibleId: 1,
  account: Account.OTHER,
  transactionType: TransactionType.POINT,
  myRegistrationStatus: JobRegistrationStatus.REGISTERED,
);

void main() {
  final cache = UserDataCache.instance;
  late Answers answers;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await cache.clear();
    await cache.open(me.id);
    await locator.reset();
    locator.registerSingleton<UserProvider>(TestUser());
    answers = Answers();
  });

  tearDown(() => answers.failAll());

  group('Status', () {
    StatusDataNotifier create() => StatusDataNotifier(
      FakeRounds(answers),
      FakeStatuses(answers),
      FakeUsers(answers),
      FakeTransactionItems(answers),
      FakeGoals(),
    );

    test('shows the cached status first, then the fresh one, and keeps that', () async {
      await cache.write(me.id, UserDataCache.status, {
        'statuses': [status(5, status: 0.3)],
        'children': [],
        'head': head,
        'transactions': [],
      });

      final notifier = create();
      expect(notifier.state.statuses, [status(5, status: 0.3)]);
      expect(notifier.state.userRoundHead, head);

      answers.answer('status 5', status(5, status: 0.8));
      answers.answer('children', <UserModel>[]);
      answers.answer('head', head.copyWith(onTrackCount: 41));
      answers.answer('transactions', PaginatedResponse<TransactionItemModel>.all([]));
      await pumpEventQueue();

      expect(notifier.state.statuses, [status(5, status: 0.8)]);
      expect(notifier.state.userRoundHead.onTrackCount, 41);
      final cached = cache.read(me.id, UserDataCache.status) as Map;
      expect(UserStatusModel.fromJson(cached['statuses'][0]).status, 0.8);
      expect(UserRoundHeadModel.fromJson(cached['head']).onTrackCount, 41);
      notifier.dispose();
    });

    test('a failed refresh keeps the cached status, without an error', () async {
      await cache.write(me.id, UserDataCache.status, {
        'statuses': [status(5)],
        'children': [],
        'head': head,
        'transactions': [],
      });

      final notifier = create();
      answers.failAll();
      await pumpEventQueue();

      expect(notifier.state.statuses, [status(5)]);
      expect(notifier.state.userRoundHead, head);
      expect(notifier.state.status.modelState.isError, isFalse);
      notifier.dispose();
    });

    test('a child\'s cached status is replaced, not doubled', () async {
      final child = me.copyWith(id: 9, firstname: 'Kid');
      await cache.write(me.id, UserDataCache.status, {
        'statuses': [status(5), status(9, status: 0.1)],
        'children': [child],
        'head': head,
        'transactions': [],
      });

      final notifier = create();
      answers.answer('children', [child]);
      answers.answer('status 9', status(9, status: 0.9));
      answers.answer('status 5', status(5));
      answers.answer('head', head);
      answers.answer('transactions', PaginatedResponse<TransactionItemModel>.all([]));
      await pumpEventQueue();

      expect(notifier.state.statuses, [status(5), status(9, status: 0.9)]);
      notifier.dispose();
    });
  });

  group('Balance', () {
    test('shows the cached balance first, then the fresh one', () async {
      await cache.write(me.id, UserDataCache.balance, {
        'account': account(1000),
        'orders': [],
        'familyAccounts': [],
        'images': [],
      });

      final notifier = HomeDataNotifier(FakeBufe(answers), FakeDonations(), FakeUsers(answers));
      expect(notifier.state.account?.balance, 1000);

      answers.answer('account 5', account(2500));
      answers.answer('children', <UserModel>[]);
      answers.answer('orders', const Order(items: [], dukappId: '5', customerId: 'c', offset: 0, limit: 10, total: 0));
      answers.answer('images', <DukappImages>[]);
      await pumpEventQueue();

      expect(notifier.state.account?.balance, 2500);
      expect(SumupUserModel.fromJson((cache.read(me.id, UserDataCache.balance) as Map)['account']).balance, 2500);
      notifier.dispose();
    });

    test('offline the cached balance stays, without an error', () async {
      await cache.write(me.id, UserDataCache.balance, {
        'account': account(1000),
        'orders': [],
        'familyAccounts': [],
        'images': [],
      });

      final notifier = HomeDataNotifier(FakeBufe(answers), FakeDonations(), FakeUsers(answers));
      answers.failAll();
      await pumpEventQueue();

      expect(notifier.state.account?.balance, 1000);
      expect(notifier.state.status.modelState.isError, isFalse);
      notifier.dispose();
    });
  });

  group('Jobs tab', () {
    PaginatedResponse<JobModel> page(List<JobModel> jobs) => PaginatedResponse.all(jobs);

    test('shows the cached jobs first, then the fresh first page, and caches that', () async {
      await cache.write(me.id, UserDataCache.jobs, {
        'items': [job(1, 'Takarítás')],
      });

      final notifier = JobsDataNotifier(FakeJobs(answers), me, manage: false);
      expect(notifier.state.items.map((j) => j.description), ['Takarítás']);
      expect(notifier.state.items.single.myRegistrationStatus, JobRegistrationStatus.REGISTERED);

      answers.answer('jobs 1', page([job(1, 'Takarítás'), job(2, 'Főzés')]));
      await pumpEventQueue();

      expect(notifier.state.items.map((j) => j.description), ['Takarítás', 'Főzés']);
      final cached = cache.parse(
        me.id,
        UserDataCache.jobs,
        (json) => [for (final j in json['items'] as List) JobModel.fromJson(j)],
      );
      expect(cached?.map((j) => j.id), [1, 2]);
      notifier.dispose();
    });

    test('a filtered list is not cached, nor the admin list', () async {
      final jobs = FakeJobs(answers);
      final notifier = JobsDataNotifier(jobs, me, manage: false);
      answers.answer('jobs 1', page([job(1, 'Takarítás')]));
      await pumpEventQueue();

      notifier.setFilter(notifier.state.query.filter.copyWith(onlyMine: true));
      answers.answer('jobs 2', page([]));
      await pumpEventQueue();
      expect((cache.read(me.id, UserDataCache.jobs) as Map)['items'], hasLength(1));

      final admin = JobsDataNotifier(FakeJobs(answers), me, manage: true);
      expect(admin.state.items, isEmpty);
      notifier.dispose();
      admin.dispose();
    });

    test('a failed refresh keeps the cached jobs', () async {
      await cache.write(me.id, UserDataCache.jobs, {
        'items': [job(1, 'Takarítás')],
      });

      final notifier = JobsDataNotifier(FakeJobs(answers), me, manage: false);
      answers.failAll();
      await pumpEventQueue();

      expect(notifier.state.items, hasLength(1));
      expect(notifier.state.baseStatus.modelState.isError, isFalse);
      notifier.dispose();
    });
  });
}
