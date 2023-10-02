import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';

part 'admin_state.freezed.dart';

@freezed
abstract class AdminState with _$AdminState {
  const factory AdminState({
      @Default(ModelState.empty) ModelState modelState,
      @Default("") String message}) = _AdminState;

  const AdminState._();
}
