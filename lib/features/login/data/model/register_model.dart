import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_model.g.dart';

part 'register_model.freezed.dart';

@freezed
abstract class RegisterModel with _$RegisterModel {

  const factory RegisterModel(
      {
      required String firstname,
      required String lastname,
      required String password,
      required String email}) = _RegisterModel;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => _$RegisterModelFromJson(json);
}
