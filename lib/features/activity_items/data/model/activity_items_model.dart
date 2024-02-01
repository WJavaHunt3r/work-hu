import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/features/activities/data/model/activity_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';

part 'activity_items_model.freezed.dart';

part 'activity_items_model.g.dart';

@freezed
class ActivityItemsModel with _$ActivityItemsModel {
  const factory ActivityItemsModel(
      {num? id,
      ActivityModel? activity,
      DateTime? createDateTime,
      required UserModel createUser,
      required String description,
      required double hours,
      required UserModel user,
      required RoundModel round,
      required TransactionType transactionType,
      required Account account}) = _ActivityItemsModel;

  factory ActivityItemsModel.fromJson(Map<String, dynamic> json) => _$ActivityItemsModelFromJson(json);
}
