import 'package:freezed_annotation/freezed_annotation.dart';

part 'bufe_account_model.freezed.dart';

part 'bufe_account_model.g.dart';

@freezed
class BufeAccountModel with _$BufeAccountModel {
  const factory BufeAccountModel({required String name, required String balance, required num id, required String sum}) =
      _BufeAccountModel;

  factory BufeAccountModel.fromJson(Map<String, dynamic> json) => _$BufeAccountModelFromJson(json);
}
