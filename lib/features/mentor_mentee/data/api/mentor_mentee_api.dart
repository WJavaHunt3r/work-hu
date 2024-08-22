import 'package:work_hu/app/framework/base_components/base_api.dart';
import 'package:work_hu/features/mentor_mentee/data/model/mentor_mentee_model.dart';

class MentorMenteeApi extends BaseApi {
  Future<List<dynamic>> getMentorMentees(num? userId) async {
    try {
      final res = await dioClient.dio.get("/mentorMentee", queryParameters: {'userId': userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postMentorMentee(MentorMenteeModel menteesModel, num? userId) async {
    try {
      final res = await dioClient.dio.post("/mentorMentee", data: menteesModel.toJson(), queryParameters: {'userId': userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteMentorMentee(num id, num? userId) async {
    try {
      final res = await dioClient.dio.delete("/mentorMentee/$id", queryParameters: {'userId': userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
