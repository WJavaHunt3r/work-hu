import 'package:dio/dio.dart';
import 'package:work_hu/features/mentor_mentee/data/api/mentor_mentee_api.dart';
import 'package:work_hu/features/mentor_mentee/data/model/mentor_mentee_model.dart';
class MentorMenteeRepository {
  final MentorMenteeApi menteesApi;

  MentorMenteeRepository(this.menteesApi);

  Future<List<MentorMenteeModel>> getMentorMentee({num? userId}) async {
    try {
      final res = await menteesApi.getMentorMentees(userId);
      return res.map((e) => MentorMenteeModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  Future<MentorMenteeModel> postMentee(MentorMenteeModel menteesModel, num userId) async {
    try {
      final res = await menteesApi.postMentorMentee(menteesModel, userId);
      return MentorMenteeModel.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<String> deleteMentee(num id, num userId) async {
    try {
      final res = await menteesApi.deleteMentorMentee(id, userId);
      return res;
    } on DioException {
      rethrow;
    }
  }
}
