import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/features/camps/data/model/camp_model.dart';

part 'camp_maintenance_state.freezed.dart';

@freezed
abstract class CampMaintenanceState with _$CampMaintenanceState {
  const factory CampMaintenanceState({
    @Default(CampModel()) CampModel selectedCamp,
    @Default(MaintenanceMode.create) MaintenanceMode mode,
  }) = _CampMaintenanceState;
}
