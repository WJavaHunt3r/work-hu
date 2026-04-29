import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/mode_state.dart';


part 'base_state.freezed.dart';

@freezed
abstract class BaseState with _$BaseState {
  const factory BaseState({
    @Default(ModelState.empty) ModelState modelState,
    @Default('') String message,
  }) = _BaseState;
}