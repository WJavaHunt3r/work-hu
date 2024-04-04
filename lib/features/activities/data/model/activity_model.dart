import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

part 'activity_model.freezed.dart';

part 'activity_model.g.dart';

@freezed
class ActivityModel with _$ActivityModel {
  const factory ActivityModel(
      {num? id,
      DateTime? createDateTime,
      required UserModel createUser,
      required String description,
      required DateTime activityDateTime,
      required UserModel employer,
      required UserModel responsible,
      num? activityId,
      required bool registeredInApp,
      required bool registeredInMyShare,
      required bool registeredInTeams,
      required TransactionType transactionType,
      required Account account}) = _ActivityModel;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);
}
