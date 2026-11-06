import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/cache/user_data_cache.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

UserModel user(num id, {String firstname = 'André'}) => UserModel(
  id: id,
  firstname: firstname,
  lastname: 'Wagner',
  role: Role.USER,
  changedPassword: true,
  birthDate: DateTime(2000, 5, 1),
  permissions: const ['MEMBER_AREA'],
);

/// Answers the requests of [DioClient] (both Dio instances) instead of the backend.
class FakeBackend extends Interceptor {
  Completer<Map<String, dynamic>> me = Completer();
  final requests = <String>[];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    requests.add(options.path);
    if (options.path == '/user/me') {
      me.future.then(
        (json) => handler.resolve(Response(requestOptions: options, data: json, statusCode: 200)),
        onError: (Object e) =>
            handler.reject(DioException.connectionError(requestOptions: options, reason: 'offline', error: e)),
      );
    } else {
      handler.resolve(Response(requestOptions: options, statusCode: 200));
    }
  }
}

Future<Map<String, dynamic>?> stored() async {
  final saved = (await SharedPreferences.getInstance()).getString('user_data_cache');
  return saved == null ? null : jsonDecode(saved) as Map<String, dynamic>;
}

void main() {
  final cache = UserDataCache.instance;
  late FakeBackend backend;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({'jwt_token': 'token', 'keep_logged_in': 'true'});
    await cache.clear();
    await locator.reset();
    final dio = DioClient();
    backend = FakeBackend();
    dio.dio.interceptors.insert(0, backend);
    dio.plainDio.interceptors.insert(0, backend);
    locator.registerSingleton<DioClient>(dio);
  });

  UserProvider provider() {
    final p = UserProvider();
    locator.registerSingleton<UserProvider>(p);
    return p;
  }

  group('UserDataCache', () {
    test('keeps the entries of one user, across starts', () async {
      await cache.open(5);
      await cache.write(5, UserDataCache.status, {'a': 1});

      expect(await cache.load(), 5);
      expect(cache.read(5, UserDataCache.status), {'a': 1});
      expect(cache.read(6, UserDataCache.status), isNull, reason: "another user's id reads nothing");
    });

    test('opening it for another user deletes the previous user\'s entries', () async {
      await cache.open(5);
      await cache.write(5, UserDataCache.balance, {'balance': 100});

      await cache.open(6);

      expect(cache.read(6, UserDataCache.balance), isNull);
      expect((await stored())!['userId'], 6);
      expect((await stored())!['entries'], isEmpty);
    });

    test('a late answer of the previous user is not stored for the new one', () async {
      await cache.open(6);
      await cache.write(5, UserDataCache.jobs, {'items': []});
      expect(cache.read(6, UserDataCache.jobs), isNull);
      expect((await stored())!['entries'], isEmpty);
    });

    test('an entry that no longer parses counts as none', () async {
      await cache.open(5);
      await cache.write(5, UserDataCache.user, {'id': 5});
      expect(cache.parse(5, UserDataCache.user, UserModel.fromJson), isNull);
    });
  });

  group('UserProvider', () {
    test('a second start shows the cached user at once and takes /user/me when it answers', () async {
      await cache.open(5);
      await cache.write(5, UserDataCache.user, user(5));
      final p = provider();
      var notified = 0;
      p.addListener(() => notified++);

      // /user/me has not answered: the start does not wait for it
      await p.initUser();
      expect(p.user, user(5));
      await pumpEventQueue();
      expect(backend.requests, contains('/user/me'));
      expect(p.user, user(5));

      backend.me.complete(user(5, firstname: 'Andreas').toJson());
      await pumpEventQueue();

      expect(p.user?.firstname, 'Andreas');
      expect(notified, 1);
      expect(cache.parse(5, UserDataCache.user, UserModel.fromJson)?.firstname, 'Andreas');
    });

    test('offline the cached user stays', () async {
      await cache.open(5);
      await cache.write(5, UserDataCache.user, user(5));
      final p = provider();

      await p.initUser();
      await pumpEventQueue();
      backend.me.completeError('offline');
      await pumpEventQueue();

      expect(p.user, user(5));
      expect(cache.parse(5, UserDataCache.user, UserModel.fromJson), user(5));
    });

    test('without a cache the start waits for /user/me and remembers the user', () async {
      final p = provider();
      backend.me.complete(user(7).toJson());

      await p.initUser();

      expect(p.user, user(7));
      expect((await stored())!['userId'], 7);
    });

    test('without a session nothing of the previous one stays', () async {
      FlutterSecureStorage.setMockInitialValues({'keep_logged_in': 'true'});
      await cache.open(5);
      await cache.write(5, UserDataCache.user, user(5));

      await provider().initUser();

      expect(await stored(), isNull);
    });

    test('logout deletes the cache', () async {
      await cache.open(5);
      await cache.write(5, UserDataCache.user, user(5));
      await cache.write(5, UserDataCache.status, {'statuses': []});
      final p = provider();
      await p.initUser();

      await p.logout();

      expect(p.user, isNull);
      expect(cache.userId, isNull);
      expect(await stored(), isNull);
    });

    test('another user signing in replaces the previous user\'s cache', () async {
      await cache.open(5);
      await cache.write(5, UserDataCache.status, {'statuses': []});
      final p = provider();

      await p.setUser(user(6));

      expect(cache.read(5, UserDataCache.status), isNull);
      expect((await stored())!['userId'], 6);
      expect(cache.parse(6, UserDataCache.user, UserModel.fromJson), user(6));
    });
  });
}
