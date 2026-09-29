import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/donation/data/api/donation_api.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/donation/data/repository/donation_repository.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

import '../data/state/donation_state.dart';

final donationApiProvider = Provider<DonationsApi>((ref) => DonationsApi());

final donationRepoProvider = Provider<DonationRepository>((ref) => DonationRepository(ref.read(donationApiProvider)));

final donationDataProvider = StateNotifierProvider.autoDispose<DonationDataNotifier, DonationState>(
  (ref) => DonationDataNotifier(ref.read(donationRepoProvider), ref.read(userDataProvider).user),
);

class DonationDataNotifier extends BaseDataNotifier<DonationState> implements ListApiProvider {
  DonationDataNotifier(this.donationRepository, this.currentUser) : super(const DonationState()) {
    startDateTimeController = TextEditingController(text: DateTime.now().toString());
    endDateTimeController = TextEditingController();
    descriptionController = TextEditingController();
    descriptionNoController = TextEditingController();

    startDateTimeController.addListener(_updateStartDate);
    endDateTimeController.addListener(_updateEndDate);
    descriptionController.addListener(_updateDescription);
    descriptionNoController.addListener(_updateNoDescription);

    list();
  }

  late final TextEditingController startDateTimeController;
  late final TextEditingController endDateTimeController;
  late final TextEditingController descriptionController;
  late final TextEditingController descriptionNoController;
  final DonationRepository donationRepository;
  final UserModel? currentUser;

  @override
  Future<void> list({filter, int? page, int? size, List<String>? sort}) async {
    await executeApiCall<List<DonationModel>>(
      () => donationRepository.getDonations(null),
      background: true,
      onSuccess: (donations) async {
        donations.sort((a, b) => b.endDateTime!.compareTo(a.endDateTime!));
        state = state.copyWith(
          donations: donations,
          listState: state.listState.copyWith(number: 0, totalPages: 1, totalElements: donations.length),
        );
      },
    );
  }

  Future<void> deleteDonation(num donationId) async {
    var origItems = state.donations;
    var origListState = state.listState;
    state = state.copyWith(
      donations: origItems.where((d) => d.id != donationId).toList(),
      listState: origListState.copyWith(totalElements: origListState.totalElements - 1),
    );
    await executeApiCall<String>(
      () => donationRepository.deleteDonation(donationId),
      onError: (error) async {
        state = state.copyWith(
          donations: origItems,
          listState: state.listState.copyWith(totalElements: origListState.totalElements),
        );
      },
    );
  }

  Future<void> updateDonation(DonationModel donation) async {
    // userController.text = "${donation.user?.getFullName()} (${donation.user?.getAge()}) ";
    state = state.copyWith(selectedDonation: donation);
  }

  Future<void> saveDonation() async {
    var mode = state.mode;
    var donation = state.selectedDonation;
    if (donation == null || (mode != MaintenanceMode.create && mode != MaintenanceMode.edit)) return;
    await executeApiCall<DonationModel>(
      () => mode == MaintenanceMode.create
          ? donationRepository.postDonation(donation, currentUser!.id)
          : donationRepository.putDonation(donation, donation.id!),
      onSuccess: (_) async {
        state = state.copyWith(selectedDonation: null);
      },
    );
  }

  void _updateStartDate() {
    state = state.copyWith(
      selectedDonation: state.selectedDonation?.copyWith(
        startDateTime: DateTime.tryParse(startDateTimeController.value.text) ?? DateTime.now(),
      ),
    );
  }

  void _updateEndDate() {
    state = state.copyWith(
      selectedDonation: state.selectedDonation?.copyWith(
        endDateTime: DateTime.tryParse(endDateTimeController.value.text) ?? DateTime.now(),
      ),
    );
  }

  void _updateDescription() {
    state = state.copyWith(
      selectedDonation: state.selectedDonation?.copyWith(description: descriptionController.value.text),
    );
  }

  void _updateNoDescription() {
    state = state.copyWith(
      selectedDonation: state.selectedDonation?.copyWith(descriptionNO: descriptionNoController.value.text),
    );
  }

  void preset(DonationModel donation, MaintenanceMode mode) {
    state = state.copyWith(selectedDonation: donation, mode: mode);
    descriptionController.text = donation.description.toString();
    descriptionNoController.text = donation.descriptionNO.toString();
    startDateTimeController.text = donation.startDateTime.toString();
    endDateTimeController.text = donation.endDateTime.toString();
  }

  @override
  DonationState copyWithState(BaseState status) {
    return state.copyWith(listState: state.listState.copyWith(baseStatus: status));
  }
}
