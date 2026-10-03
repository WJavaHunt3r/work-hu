import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';

part 'round_detail_state.freezed.dart';

@freezed
abstract class RoundDetailState with _$RoundDetailState {
  const factory RoundDetailState({RoundModel? round, @Default(BaseState()) BaseState status}) = _RoundDetailState;
}
