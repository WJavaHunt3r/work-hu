import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';

part 'activity_items_model.freezed.dart';
part 'activity_items_model.g.dart';

@freezed
abstract class ActivityItemsModel with _$ActivityItemsModel {
  const factory ActivityItemsModel({
    num? id,
    num? activityId,
    DateTime? createDateTime,
    required num createUserId,
    required String createUserName,
    required String description,
    required double hours,
    required String userName,
    required num userId,
    required num roundId,
    required TransactionType transactionType,
    required Account account,
  }) = _ActivityItemsModel;

  factory ActivityItemsModel.fromJson(Map<String, dynamic> json) => _$ActivityItemsModelFromJson(json);
}
