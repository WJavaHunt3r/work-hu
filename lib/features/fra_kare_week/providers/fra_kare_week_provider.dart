import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/fra_kare_week/data/api/fra_kare_week_api.dart';
import 'package:work_hu/features/fra_kare_week/data/model/fra_kare_week_model.dart';
import 'package:work_hu/features/fra_kare_week/data/repository/fra_kare_week_repository.dart';
import 'package:work_hu/features/fra_kare_week/data/state/fra_kare_week_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

final fraKareWeekApiProvider = Provider<FraKareWeekApi>((ref) => FraKareWeekApi());

final fraKareWeekRepoProvider = Provider<FraKareWeekRepository>(
  (ref) => FraKareWeekRepository(ref.read(fraKareWeekApiProvider)),
);

final fraKareWeekDataProvider = StateNotifierProvider.autoDispose<FraKareWeekDataNotifier, FraKareWeekState>(
  (ref) => FraKareWeekDataNotifier(ref.read(fraKareWeekRepoProvider), ref.read(userDataProvider).user),
);

class FraKareWeekDataNotifier extends BaseDataNotifier<FraKareWeekState> implements ListApiProvider {
  FraKareWeekDataNotifier(this.fraKareWeekRepository, this.currentProvider) : super(const FraKareWeekState()) {
    list();
  }

  final FraKareWeekRepository fraKareWeekRepository;
  final UserModel? currentProvider;

  @override
  Future<void> list({filter, int? page, int? size, List<String>? sort}) async {
    await executeApiCall<List<FraKareWeekModel>>(
      () => fraKareWeekRepository.getFraKareWeeks(year: DateTime.now().year),
      background: true,
      onSuccess: (weeks) async {
        state = state.copyWith(
          weeks: weeks,
          listState: state.listState.copyWith(number: 0, totalPages: 1, totalElements: weeks.length),
        );
      },
    );
  }

  @override
  FraKareWeekState copyWithState(BaseState status) {
    return state.copyWith(listState: state.listState.copyWith(baseStatus: status));
  }
}
