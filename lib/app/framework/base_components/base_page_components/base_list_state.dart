import 'package:freezed_annotation/freezed_annotation.dart';

import 'base_state.dart';

part 'base_list_state.freezed.dart';

@freezed
abstract class BaseListState with _$BaseListState {
  const factory BaseListState({
    @Default(0) int number,
    @Default(0) int totalElements,
    @Default(30) int size,
    @Default(0) int totalPages,
    @Default(BaseState()) BaseState baseStatus,
  }) = _BaseListState;

  const BaseListState._();
}
