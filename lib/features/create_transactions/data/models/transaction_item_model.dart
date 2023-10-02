import 'dart:core';
import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/round_model.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';

part 'transaction_item_model.freezed.dart';
part 'transaction_item_model.g.dart';

@freezed
class TransactionItemModel with _$TransactionItemModel{
  const factory TransactionItemModel(
      {num? id,
      num? transactionId,
      required DateTime transactionDate,
      required String description,
      required num userId,
      required num createUserId,
      required double points,
      required TransactionType transactionType,
      required Account account,
      required num credit,
      required num hours,
      RoundModel? round}) = _TransactionItemModel;

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) => _$TransactionItemModelFromJson(json);
}
