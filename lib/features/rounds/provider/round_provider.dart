import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/rounds/data/api/round_api.dart';
import 'package:work_hu/features/rounds/data/repository/round_repository.dart';
import 'package:work_hu/features/rounds/data/state/rounds_state.dart';

final roundApiProvider = Provider<RoundApi>((ref) => RoundApi());

final roundRepoProvider = Provider<RoundRepository>((ref) => RoundRepository(ref.read(roundApiProvider)));

final roundDataProvider =
    StateNotifierProvider<RoundDataNotifier, RoundsState>((ref) => RoundDataNotifier(ref.read(roundRepoProvider)));

class RoundDataNotifier extends StateNotifier<RoundsState> {
  RoundDataNotifier(
    this.roundRepository,
  ) : super(const RoundsState()) {
    getRounds();
  }

  final RoundRepository roundRepository;

  Future<void> getRounds() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await roundRepository.getRounds().then((data) async {
        data.sort((a, b) => a.roundNumber.compareTo(b.roundNumber));
        state = state.copyWith(rounds: data, modelState: ModelState.success);
      });

      await roundRepository.getCurrentRounds().then(
          (value) => state = state.copyWith(currentRoundNumber: value.roundNumber, modelState: ModelState.success));
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }
}
