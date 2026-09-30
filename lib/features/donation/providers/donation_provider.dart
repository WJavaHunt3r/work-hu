import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/donation/data/api/donation_api.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/donation/data/repository/donation_repository.dart';
import 'package:work_hu/features/donation/data/state/donation_maintenance_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

final donationApiProvider = Provider<DonationsApi>((ref) => DonationsApi());

final donationRepoProvider = Provider<DonationRepository>((ref) => DonationRepository(ref.read(donationApiProvider)));

final donationDataProvider = StateNotifierProvider.autoDispose<DonationDataNotifier, PagedState<DonationModel, void>>(
  (ref) => DonationDataNotifier(ref.read(donationRepoProvider)),
);

final donationMaintenanceProvider =
    StateNotifierProvider.autoDispose<DonationMaintenanceNotifier, DonationMaintenanceState>(
      (ref) => DonationMaintenanceNotifier(ref.read(donationRepoProvider), ref.read(userDataProvider).user),
    );

class DonationDataNotifier extends PagedListNotifier<DonationModel, void> {
  DonationDataNotifier(this.donationRepository) : super(const ListQuery(filter: null));

  final DonationRepository donationRepository;

  /// Not paged by the server: returns every donation at once, latest ending first.
  @override
  Future<PaginatedResponse<DonationModel>> fetch(ListQuery<void> query, int page) async {
    final donations = await donationRepository.getDonations(null);
    donations.sort((a, b) => b.endDateTime!.compareTo(a.endDateTime!));
    return PaginatedResponse.all(donations);
  }

  Future<void> deleteDonation(num donationId) async {
    await executeApiCall<String>(
      () => donationRepository.deleteDonation(donationId),
      onSuccess: (_) async => removeItems((d) => d.id == donationId),
    );
  }
}

/// The donation being created or edited in the maintenance dialog.
class DonationMaintenanceNotifier extends BaseDataNotifier<DonationMaintenanceState> {
  DonationMaintenanceNotifier(this.donationRepository, this.currentUser) : super(const DonationMaintenanceState()) {
    startDateTimeController.addListener(_updateStartDate);
    endDateTimeController.addListener(_updateEndDate);
    descriptionController.addListener(_updateDescription);
    descriptionNoController.addListener(_updateNoDescription);
  }

  final TextEditingController startDateTimeController = TextEditingController(text: DateTime.now().toString());
  final TextEditingController endDateTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController descriptionNoController = TextEditingController();
  final DonationRepository donationRepository;
  final UserModel? currentUser;

  Future<void> updateDonation(DonationModel donation) async {
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
  DonationMaintenanceState copyWithState(BaseState status) => state.copyWith(status: status);

  @override
  void dispose() {
    startDateTimeController.dispose();
    endDateTimeController.dispose();
    descriptionController.dispose();
    descriptionNoController.dispose();
    super.dispose();
  }
}
