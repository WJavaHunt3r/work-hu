import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';

part 'donation_state.freezed.dart';

@freezed
abstract class DonationState with _$DonationState {
  const factory DonationState(
      {
        @Default([]) List<DonationModel> donations,
        DonationModel? selectedDonation,
        @Default(MaintenanceMode.create) MaintenanceMode mode,
        @Default(ModelState.empty) ModelState modelState,
        @Default("") String message}) = _DonationState;

  const DonationState._();


}