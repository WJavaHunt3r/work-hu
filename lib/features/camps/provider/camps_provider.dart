import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/features/camps/data/api/camps_api.dart';
import 'package:work_hu/features/camps/data/model/camp_filter.dart';
import 'package:work_hu/features/camps/data/model/camp_model.dart';
import 'package:work_hu/features/camps/data/repository/camp_repository.dart';
import 'package:work_hu/features/camps/data/state/camp_maintenance_state.dart';
import 'package:work_hu/features/season/data/repository/season_repository.dart';
import 'package:work_hu/features/season/provider/season_provider.dart';

final campsApiProvider = Provider<CampApi>((ref) => CampApi());

final campsRepoProvider = Provider<CampRepository>((ref) => CampRepository(ref.read(campsApiProvider)));

final campsDataProvider = StateNotifierProvider.autoDispose<CampDataNotifier, PagedState<CampModel, CampFilter>>(
  (ref) => CampDataNotifier(ref.read(campsRepoProvider)),
);

final campMaintenanceProvider = StateNotifierProvider.autoDispose<CampMaintenanceNotifier, CampMaintenanceState>(
  (ref) => CampMaintenanceNotifier(ref.read(campsRepoProvider), ref.read(seasonRepoProvider)),
);

class CampDataNotifier extends PagedListNotifier<CampModel, CampFilter> {
  // No explicit sort: camps have no user to sort by, so the server's default order applies.
  CampDataNotifier(this.campsRepository) : super(ListQuery(filter: CampFilter(seasonYear: DateTime.now().year)));

  final CampRepository campsRepository;

  @override
  Future<PaginatedResponse<CampModel>> fetch(ListQuery<CampFilter> query, int page) =>
      campsRepository.getCamps(query, page: page);

  Future<void> deleteCamp(num campId) async {
    await executeApiCall(
      () => campsRepository.deleteCamp(campId),
      onSuccess: (_) async => removeItems((camp) => camp.id == campId),
    );
  }
}

/// The camp being created or edited in the maintenance dialog.
class CampMaintenanceNotifier extends StateNotifier<CampMaintenanceState> {
  CampMaintenanceNotifier(this.campsRepository, this.seasonRepository) : super(const CampMaintenanceState());

  final CampRepository campsRepository;
  final SeasonRepository seasonRepository;

  Future<void> updateCamp(CampModel camp) async {
    state = state.copyWith(selectedCamp: camp);
  }

  Future<void> saveCamp() async {
    var mode = state.mode;
    var camp = state.selectedCamp;
    if (camp.season != null && camp.campDate != null) {
      if (mode == MaintenanceMode.create) {
        await campsRepository.postCamp(camp);
      } else if (mode == MaintenanceMode.edit) {
        await campsRepository.putCamp(camp, camp.id!);
      }
      state = state.copyWith(selectedCamp: const CampModel());
    }
  }

  Future<void> presetCamp(CampModel camp, MaintenanceMode mode) async {
    if (camp.season == null) {
      final seasons = await seasonRepository.getSeasons();
      camp = camp.copyWith(season: seasons.firstWhere((s) => s.seasonYear == DateTime.now().year));
    }
    state = state.copyWith(selectedCamp: camp, mode: mode);
  }
}
