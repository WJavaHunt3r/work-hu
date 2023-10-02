// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TransactionModel _$$_TransactionModelFromJson(Map<String, dynamic> json) =>
    _$_TransactionModel(
      id: json['id'] as num?,
      name: json['name'] as String,
      createDateTime: json['createDateTime'] == null
          ? null
          : DateTime.parse(json['createDateTime'] as String),
      transactionCount: json['transactionCount'] as num?,
      account: $enumDecode(_$AccountEnumMap, json['account']),
    );

Map<String, dynamic> _$$_TransactionModelToJson(_$_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createDateTime': instance.createDateTime?.toIso8601String(),
      'transactionCount': instance.transactionCount,
      'account': _$AccountEnumMap[instance.account]!,
    };

const _$AccountEnumMap = {
  Account.SAMVIRK: 'SAMVIRK',
  Account.MYSHARE: 'MYSHARE',
  Account.OTHER: 'OTHER',
};
