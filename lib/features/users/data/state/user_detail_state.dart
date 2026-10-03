import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

part 'user_detail_state.freezed.dart';

@freezed
abstract class UserDetailState with _$UserDetailState {
  const factory UserDetailState({UserModel? selectedUser, @Default(BaseState()) BaseState status}) = _UserDetailState;
}
