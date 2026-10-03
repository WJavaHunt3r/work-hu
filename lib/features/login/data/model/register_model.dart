import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/gender.dart';

part 'register_model.freezed.dart';
part 'register_model.g.dart';

@freezed
abstract class RegisterModel with _$RegisterModel {
  const factory RegisterModel({
    required String firstname,
    required String lastname,
    required String password,
    required String email,
    Gender? gender,
  }) = _RegisterModel;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => _$RegisterModelFromJson(json);
}
