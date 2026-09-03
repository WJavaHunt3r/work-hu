import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/camps/data/model/camp_filter.dart';
import 'package:work_hu/features/camps/data/model/camp_model.dart';

part 'camp_state.freezed.dart';

@freezed
abstract class CampState with _$CampState {
  const factory CampState(
      {@Default([]) List<CampModel> camps,
      @Default(CampFilter()) CampFilter filter,
        @Default(CampModel()) CampModel selectedCamp,
      @Default(BaseListState()) BaseListState listState,
      @Default(MaintenanceMode.create) MaintenanceMode mode}) = _CampState;

  const CampState._();
}
