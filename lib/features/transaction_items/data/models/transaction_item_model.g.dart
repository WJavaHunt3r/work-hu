// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TransactionItemModel _$$_TransactionItemModelFromJson(
        Map<String, dynamic> json) =>
    _$_TransactionItemModel(
      id: json['id'] as num?,
      transactionId: json['transactionId'] as num?,
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      description: json['description'] as String,
      createUserId: json['createUserId'] as num,
      points: (json['points'] as num).toDouble(),
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
      account: $enumDecode(_$AccountEnumMap, json['account']),
      credit: json['credit'] as num,
      hours: json['hours'] as num,
      round: json['round'] == null
          ? null
          : RoundModel.fromJson(json['round'] as Map<String, dynamic>),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_TransactionItemModelToJson(
        _$_TransactionItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionId': instance.transactionId,
      'transactionDate': instance.transactionDate.toIso8601String(),
      'description': instance.description,
      'createUserId': instance.createUserId,
      'points': instance.points,
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
      'account': _$AccountEnumMap[instance.account]!,
      'credit': instance.credit,
      'hours': instance.hours,
      'round': instance.round,
      'user': instance.user,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.HOURS: 'HOURS',
  TransactionType.CREDIT: 'CREDIT',
  TransactionType.POINT: 'POINT',
  TransactionType.VAER_ET_FORBILDE: 'VAER_ET_FORBILDE',
};

const _$AccountEnumMap = {
  Account.SAMVIRK: 'SAMVIRK',
  Account.MYSHARE: 'MYSHARE',
  Account.OTHER: 'OTHER',
};
