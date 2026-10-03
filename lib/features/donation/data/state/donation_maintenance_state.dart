import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';

part 'donation_maintenance_state.freezed.dart';

@freezed
abstract class DonationMaintenanceState with _$DonationMaintenanceState {
  const factory DonationMaintenanceState({
    DonationModel? selectedDonation,
    @Default(MaintenanceMode.create) MaintenanceMode mode,
    @Default(BaseState()) BaseState status,
  }) = _DonationMaintenanceState;
}
