import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';

part 'top_ups_state.freezed.dart';

@freezed
abstract class TopUpsState with _$TopUpsState {
  const factory TopUpsState({
    @Default([]) List<TopUpEntry> topUps,
    @Default(BaseListState()) BaseListState listStatus,
  }) = _TopUpsState;

  const TopUpsState._();
}
