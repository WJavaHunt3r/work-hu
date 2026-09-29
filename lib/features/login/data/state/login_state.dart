import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({@Default([]) List<DonationModel> donations, @Default(BaseState()) BaseState status}) =
      _LoginState;

  const LoginState._();
}
