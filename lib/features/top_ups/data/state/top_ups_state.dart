import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe/data/model/sumup_user_model.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';

part 'top_ups_state.freezed.dart';

@freezed
abstract class TopUpsState with _$TopUpsState {
  const factory TopUpsState({
    @Default([]) List<TopUpEntry> topUps,
    @Default(BaseListState()) BaseListState listStatus,
  }) = _TopUpsState;

  const TopUpsState._();
}
