import 'package:work_hu/features/goal/data/model/goal_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/utils.dart';

class UserGoalUserRoundModel {
  UserGoalUserRoundModel({required this.user, required this.goal, required this.round});

  final UserModel user;
  final GoalModel goal;
  final RoundModel round;

  @override
  String toString() {
    return "${user.getFullName()} ${Utils.percentFormat.format(user.currentMyShareCredit / goal.goal)} ${goal.goal * round.myShareGoal / 100}";
  }

  bool isOnTrack() => getStatus() >= round.myShareGoal;

  num getStatus() => user.currentMyShareCredit / goal.goal * 100;

  String getStatusString() => "${Utils.percentFormat.format(user.currentMyShareCredit / goal.goal * 100)}%";

  String getRemainingAmount() =>
      "${Utils.creditFormatting(goal.goal * round.myShareGoal / 100 - user.currentMyShareCredit)}Ft to be On Track";
}
