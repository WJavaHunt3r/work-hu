import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/features/mailing/data/api/mailing_api.dart';
import 'package:work_hu/features/mailing/data/model/mailing_models.dart';

class MailingRepository {
  MailingRepository(this._api);

  final MailingApi _api;

  Future<MailingRecipientsModel> getRecipients() =>
      guardApi(() async => MailingRecipientsModel.fromJson(await _api.getRecipients() as Map<String, dynamic>));

  Future<void> sendTest(String subject, String bodyHtml) => guardApi(() => _api.sendTest(subject, bodyHtml));

  Future<MailingModel> send(String subject, String bodyHtml) =>
      guardApi(() async => MailingModel.fromJson(await _api.send(subject, bodyHtml) as Map<String, dynamic>));

  Future<List<MailingModel>> getHistory({int page = 0}) => guardApi(() async {
    final res = await _api.getHistory(page) as Map<String, dynamic>;
    return (res['content'] as List).map((e) => MailingModel.fromJson(e as Map<String, dynamic>)).toList();
  });
}
