import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/fra_kare_week/data/api/fra_kare_week_api.dart';
import 'package:work_hu/features/fra_kare_week/data/repository/fra_kare_week_repository.dart';
import 'package:work_hu/features/fra_kare_week/data/state/fra_kare_week_state.dart';

final fraKareWeekApiProvider = Provider<FraKareWeekApi>((ref) => FraKareWeekApi());

final fraKareWeekRepoProvider =
    Provider<FraKareWeekRepository>((ref) => FraKareWeekRepository(ref.read(fraKareWeekApiProvider)));

final fraKareWeekDataProvider = StateNotifierProvider.autoDispose<FraKareWeekDataNotifier, FraKareWeekState>(
    (ref) => FraKareWeekDataNotifier(ref.read(fraKareWeekRepoProvider), ref.read(userDataProvider.notifier)));

class FraKareWeekDataNotifier extends StateNotifier<FraKareWeekState> {
  FraKareWeekDataNotifier(
    this.fraKareWeekRepository,
    this.currentProvider,
  ) : super(const FraKareWeekState()) {
    getFraKareWeeks(DateTime.now().year);
  }

  final FraKareWeekRepository fraKareWeekRepository;
  final UserDataNotifier currentProvider;

  Future<void> getFraKareWeeks(num year) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await fraKareWeekRepository.getFraKareWeeks(year: year).then((data) async {
        state = state.copyWith(weeks: data, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }
}
