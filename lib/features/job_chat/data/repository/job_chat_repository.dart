import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/features/job_chat/data/api/job_chat_api.dart';
import 'package:work_hu/features/job_chat/data/model/job_chat_models.dart';

class JobChatRepository {
  JobChatRepository(this._api);

  final JobChatApi _api;

  Future<JobChatModel> getChat(num jobId, {num? after, num? before}) =>
      guardApi(() async => JobChatModel.fromJson(await _api.getChat(jobId, after: after, before: before)));

  Future<JobChatMessageModel> send(num jobId, String text) =>
      guardApi(() async => JobChatMessageModel.fromJson(await _api.send(jobId, text)));

  Future<JobChatPeopleModel> getPeople(num jobId) =>
      guardApi(() async => JobChatPeopleModel.fromJson(await _api.getPeople(jobId)));

  Future<void> addMember(num jobId, num userId) => guardApi(() => _api.addMember(jobId, userId));

  Future<void> removeMember(num jobId, num userId) => guardApi(() => _api.removeMember(jobId, userId));

  Future<void> setMuted(num jobId, bool muted) => guardApi(() => _api.setMuted(jobId, muted));
}
