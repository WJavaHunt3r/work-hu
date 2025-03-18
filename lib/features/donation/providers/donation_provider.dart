import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/donation/data/api/donation_api.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/donation/data/repository/donation_repository.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/utils.dart';

import '../../bufe/data/repository/bufe_repository.dart';
import '../../bufe/providers/bufe_provider.dart';
import '../data/state/donation_state.dart';

final donationApiProvider = Provider<DonationsApi>((ref) => DonationsApi());

final donationRepoProvider = Provider<DonationRepository>((ref) => DonationRepository(ref.read(donationApiProvider)));

final donationDataProvider = StateNotifierProvider.autoDispose<DonationDataNotifier, DonationState>(
    (ref) => DonationDataNotifier(ref.read(donationRepoProvider), ref.read(userDataProvider)));

class DonationDataNotifier extends StateNotifier<DonationState> {
  DonationDataNotifier(this.donationRepository, this.currentUser) : super(const DonationState()) {
    startDateTimeController = TextEditingController(text: DateTime.now().toString());
    endDateTimeController = TextEditingController();
    descriptionController = TextEditingController();
    descriptionNoController = TextEditingController();

    startDateTimeController.addListener(_updateStartDate);
    endDateTimeController.addListener(_updateEndDate);
    descriptionController.addListener(_updateDescription);
    descriptionNoController.addListener(_updateNoDescription);
  }

  late final TextEditingController startDateTimeController;
  late final TextEditingController endDateTimeController;
  late final TextEditingController descriptionController;
  late final TextEditingController descriptionNoController;
  final DonationRepository donationRepository;
  final UserModel? currentUser;

  Future<void> getDonations(DateTime? dateTime) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await donationRepository.getDonations(dateTime).then((donations) {
        donations.sort((a, b) => b.endDateTime!.compareTo(a.endDateTime!));
        state = state.copyWith(donations: donations, modelState: ModelState.success);
      });
    } on DioException {
      state = state.copyWith(modelState: ModelState.error, message: "Failed to fetch donations ");
    }
  }

  Future<void> deleteDonations(num donationId, int index) async {
    List<DonationModel> origItems = state.donations;
    List<DonationModel> items = [...origItems];
    items.removeWhere((a) => a.id != donationId);
    state = state.copyWith(donations: items, modelState: ModelState.processing);
    try {
      await donationRepository
          .deleteDonation(donationId)
          .then((value) => state = state.copyWith(donations: items, modelState: ModelState.success));
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, donations: origItems);
    }
  }

  Future<void> updateDonation(DonationModel donation) async {
    // userController.text = "${donation.user?.getFullName()} (${donation.user?.getAge()}) ";
    state = state.copyWith(selectedDonation: donation);
  }

  Future<void> saveDonation() async {
    var mode = state.mode;
    state = state.copyWith(modelState: ModelState.processing);
    var donation = state.selectedDonation;
    try {
      if (donation != null) {
        if (mode == MaintenanceMode.create) {
          await donationRepository.postDonation(donation, currentUser!.id);
        } else if (mode == MaintenanceMode.edit) {
          await donationRepository.putDonation(donation, donation.id!);
        }
        state = state.copyWith(selectedDonation: null, modelState: ModelState.success);
      } else{
        state = state.copyWith(modelState: ModelState.error, message: "Error");
      }
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  void _updateStartDate() {
    state = state.copyWith(
        selectedDonation: state.selectedDonation
            ?.copyWith(startDateTime: DateTime.tryParse(startDateTimeController.value.text) ?? DateTime.now()));
  }

  void _updateEndDate() {
    state = state.copyWith(
        selectedDonation: state.selectedDonation
            ?.copyWith(endDateTime: DateTime.tryParse(endDateTimeController.value.text) ?? DateTime.now()));
  }

  void _updateDescription() {
    state = state.copyWith(selectedDonation: state.selectedDonation
        ?.copyWith(description: descriptionController.value.text));
  }

  void _updateNoDescription() {
    state = state.copyWith(selectedDonation: state.selectedDonation
        ?.copyWith(descriptionNO: descriptionNoController.value.text));
  }

  void preset(DonationModel donation, MaintenanceMode mode) {
    state = state.copyWith(selectedDonation: donation,mode: mode);
    descriptionController.text = donation.description.toString();
    descriptionNoController.text = donation.descriptionNO.toString();
    startDateTimeController.text = donation.startDateTime.toString();
    endDateTimeController.text = donation.endDateTime.toString();
  }
}
