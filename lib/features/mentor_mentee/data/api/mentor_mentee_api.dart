import 'package:work_hu/app/framework/base_components/base_api.dart';
import 'package:work_hu/features/mentor_mentee/data/model/mentor_mentee_model.dart';

class MentorMenteeApi extends BaseApi {
  Future<List<dynamic>> getMentorMentee(num? userId) async {
    try {
      final res = await dioClient.dio.get("/mentees", queryParameters: {'userId': userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postMentorMentee(MentorMenteeModel menteesModel, num? userId) async {
    try {
      final res = await dioClient.dio.post("/mentorMentee", data: menteesModel, queryParameters: {'userId': userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteMentorMentee(num id, num? userId) async {
    try {
      final res = await dioClient.dio.delete("/mentorMentee", queryParameters: {'id': id, 'userId': userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
