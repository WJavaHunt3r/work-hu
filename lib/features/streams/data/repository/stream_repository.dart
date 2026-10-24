import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/features/streams/data/api/stream_api.dart';
import 'package:work_hu/features/streams/data/model/live_stream_model.dart';
import 'package:work_hu/features/streams/data/model/stream_model.dart';

class StreamRepository {
  StreamRepository(this._api);

  final StreamApi _api;

  Future<List<StreamModel>> getStreams() => guardApi(() async {
    final res = await _api.getStreams();
    return res.map((e) => StreamModel.fromJson(e as Map<String, dynamic>)).toList();
  });

  Future<List<LiveStreamModel>> getLiveStreams() => guardApi(() async {
    final res = await _api.getLiveStreams();
    return res.map((e) => LiveStreamModel.fromJson(e as Map<String, dynamic>)).toList();
  });

  Future<StreamModel> startStream(String title, String language) =>
      guardApi(() async => StreamModel.fromJson(await _api.startStream(title, language) as Map<String, dynamic>));

  Future<StreamModel> updateStream(String uid, String title, String language) =>
      guardApi(() async => StreamModel.fromJson(await _api.updateStream(uid, title, language) as Map<String, dynamic>));

  Future<void> deleteStream(String uid) => guardApi(() => _api.deleteStream(uid));
}
