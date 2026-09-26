import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/framework/base_components/page_stru.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/framework/base_components/sort_builder.dart';
import 'package:work_hu/app/models/maintenance_mode.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/camps/data/api/camps_api.dart';
import 'package:work_hu/features/camps/data/model/camp_filter.dart';
import 'package:work_hu/features/camps/data/model/camp_model.dart';
import 'package:work_hu/features/camps/data/repository/camp_repository.dart';
import 'package:work_hu/features/camps/data/state/camp_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/season/data/repository/season_repository.dart';
import 'package:work_hu/features/season/provider/season_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

import '../../../app/providers/base_provider.dart';

final campsApiProvider = Provider<CampApi>((ref) => CampApi());

final campsRepoProvider = Provider<CampRepository>((ref) => CampRepository(ref.read(campsApiProvider)));

final campsDataProvider = StateNotifierProvider.autoDispose<CampDataNotifier, CampState>((ref) => CampDataNotifier(
    ref.read(campsRepoProvider), ref.read(usersRepoProvider), ref.read(seasonRepoProvider), ref.read(userDataProvider).user));

class CampDataNotifier extends BaseDataNotifier<CampState> implements ListApiProvider<CampFilter> {
  CampDataNotifier(
    this.campsRepository,
    this.usersRepository,
    this.seasonRepository,
    this.currentUserProvider,
  ) : super(CampState(
            filter: CampFilter(seasonYear: DateTime.now().year),
            listState: BaseListState(
                sort: (SortBuilder()
                      ..add("user.lastname", descending: false)
                      ..add("user.firstname", descending: false))
                    .build()))) {
    list();
  }

  final CampRepository campsRepository;
  final UsersRepository usersRepository;
  final SeasonRepository seasonRepository;
  final UserModel? currentUserProvider;

  @override
  Future<void> list({CampFilter? filter, int? page, int? size, List<String>? sort}) async {
    await executeApiCall<PaginatedResponse<CampModel>>(
        () => campsRepository.getCamps(
            filter: filter ?? state.filter,
            pageStru: PageStru(
                page: page ?? state.listState.number,
                size: size ?? state.listState.size,
                sort: sort ?? state.listState.sort)), background: true, onSuccess: (data) async {
      state = state.copyWith(
          camps: page == 0 ? data.content : [...state.camps, ...data.content],
          listState: state.listState
              .copyWith(totalElements: data.page.totalElements, totalPages: data.page.totalPages, number: data.page.number));
    });
  }

  Future<void> deleteCamp(num campsId) async {
    List<CampModel> origItems = state.camps;
    List<CampModel> items = [...origItems];
    items.removeWhere((a) => a.id != campsId);
    executeApiCall(() => campsRepository.deleteCamp(campsId), onSuccess: (data) async {
      state = state.copyWith(camps: items);
    }, onError: (error) async {
      state = state.copyWith(camps: origItems);
    });
  }

  Future<void> updateCamp(CampModel camps) async {
    state = state.copyWith(selectedCamp: camps);
  }

  Future<void> saveCamp() async {
    var mode = state.mode;
    var camp = state.selectedCamp;
    if (camp != null && camp.season != null && camp.campDate != null) {
      if (mode == MaintenanceMode.create) {
        await campsRepository.postCamp(state.selectedCamp!);
      } else if (mode == MaintenanceMode.edit) {
        await campsRepository.putCamp(state.selectedCamp!, state.selectedCamp!.id!);
      }
      state = state.copyWith(selectedCamp: const CampModel());
    }
  }

  Future<void> presetCamp(CampModel camps, MaintenanceMode mode) async {
    if (camps.season == null) {
      await seasonRepository
          .getSeasons()
          .then((value) => camps = camps.copyWith(season: value.firstWhere((s) => s.seasonYear == DateTime.now().year)));
    } else {}
    state = state.copyWith(selectedCamp: camps, mode: mode);
  }

  @override
  CampState copyWithState(BaseState status) {
    return state.copyWith(listState: state.listState.copyWith(baseStatus: status));
  }
}
