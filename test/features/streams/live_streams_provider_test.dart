import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/streams/data/api/stream_api.dart';
import 'package:work_hu/features/streams/data/repository/stream_repository.dart';
import 'package:work_hu/features/streams/providers/streams_provider.dart';

class _FakeStreamApi implements StreamApi {
  int liveCalls = 0;

  @override
  Future<List<dynamic>> getLiveStreams() async {
    liveCalls++;
    return [
      {'uid': 'u', 'title': 'Sunday', 'language': 'hu', 'hlsUrl': 'h', 'iframeUrl': 'i'},
    ];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeUser extends ChangeNotifier implements UserProvider {
  _FakeUser(this.churchId);

  final num? churchId;

  @override
  UserModel? get user =>
      UserModel(id: 1, firstname: 'T', lastname: 'U', role: Role.USER, changedPassword: true, churchId: churchId);

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  ProviderContainer containerFor(num? churchId, _FakeStreamApi api) {
    final container = ProviderContainer(
      overrides: [
        streamRepoProvider.overrideWithValue(StreamRepository(api)),
        userDataProvider.overrideWith((ref) => _FakeUser(churchId)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('members get the streams on the air', () async {
    final api = _FakeStreamApi();
    final container = containerFor(1, api);

    container.listen(liveStreamsProvider, (_, _) {}); // a screen listens, which keeps the provider alive
    final live = await container.read(liveStreamsProvider.future);

    expect(live.single.title, 'Sunday');
    expect(api.liveCalls, 1);
  });

  test('users without a church get nothing and the server is not even asked', () async {
    final api = _FakeStreamApi();
    final container = containerFor(null, api);

    container.listen(liveStreamsProvider, (_, _) {}); // a screen listens, which keeps the provider alive
    final live = await container.read(liveStreamsProvider.future);

    expect(live, isEmpty);
    expect(api.liveCalls, 0);
  });
}
