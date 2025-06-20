import 'package:work_hu/features/rounds/data/model/round_model.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/utils.dart';

class UserGoalUserRoundModel {
  UserGoalUserRoundModel({required this.userStatus, required this.round});

  final UserStatusModel userStatus;
  final RoundModel round;

  @override
  String toString() {
    return "${userStatus.user.getFullName()} ${Utils.percentFormat.format(userStatus.transactions)} ${userStatus.goal * (round.localMyShareGoal ?? round.myShareGoal) / 100}";
  }

  bool isOnTrack() => userStatus.onTrack;

  num getStatus() => userStatus.status * 100;

  String getStatusString() =>
      "${Utils.percentFormat.format(userStatus.status * 100)}%";

  String getRemainingAmount() =>
      "${Utils.creditFormatting(userStatus.goal * (round.localMyShareGoal ?? round.myShareGoal) / 100 - userStatus.transactions)}Ft to be On Track";
}
