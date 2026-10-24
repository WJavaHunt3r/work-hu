import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/streams/data/api/stream_api.dart';
import 'package:work_hu/features/streams/data/model/live_stream_model.dart';
import 'package:work_hu/features/streams/data/model/stream_model.dart';
import 'package:work_hu/features/streams/data/repository/stream_repository.dart';

final streamRepoProvider = Provider<StreamRepository>((ref) => StreamRepository(StreamApi()));

/// The live inputs with their stream keys; refresh it after starting or deleting one.
final streamsProvider = FutureProvider.autoDispose<List<StreamModel>>(
  (ref) => ref.read(streamRepoProvider).getStreams(),
);

/// The streams on the air, asked again every 15 seconds. Any failure (not signed in, the server has no Cloudflare
/// setup) counts as "nothing is live", so the Live tab and banner simply stay away. The broadcasts are for the members
/// (users who belong to a church): for everybody else nothing is asked and nothing is live.
final liveStreamsProvider = StreamProvider.autoDispose<List<LiveStreamModel>>((ref) async* {
  final user = ref.watch(userDataProvider).user;
  if (user == null || !user.hasChurch()) {
    yield const <LiveStreamModel>[];
    return;
  }
  final repo = ref.read(streamRepoProvider);
  while (true) {
    try {
      yield await repo.getLiveStreams();
    } catch (_) {
      yield const <LiveStreamModel>[];
    }
    await Future<void>.delayed(const Duration(seconds: 15));
  }
});
