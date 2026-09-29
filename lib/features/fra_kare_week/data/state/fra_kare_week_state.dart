import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/features/fra_kare_week/data/model/fra_kare_week_model.dart';

part 'fra_kare_week_state.freezed.dart';

@freezed
abstract class FraKareWeekState with _$FraKareWeekState {
  const factory FraKareWeekState({
    @Default([]) List<FraKareWeekModel> weeks,
    @Default(BaseListState()) BaseListState listState,
  }) = _FraKareWeekkState;

  const FraKareWeekState._();
}
