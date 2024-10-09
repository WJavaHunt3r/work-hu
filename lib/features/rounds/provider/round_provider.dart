import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/rounds/data/api/round_api.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';
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
    getRounds(DateTime.now().year);
  }

  final RoundRepository roundRepository;

  Future<void> getRounds([num? seasonYear]) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await roundRepository.getRounds(seasonYear).then((data) async {
        data.sort((a, b) => a.roundNumber.compareTo(b.roundNumber));
        state = state.copyWith(
            rounds: data.where((element) => element.startDateTime.compareTo(DateTime.now()) < 0).toList(),
            modelState: ModelState.success);
      });

      await roundRepository.getCurrentRounds().then(
          (value) => state = state.copyWith(currentRoundNumber: value.roundNumber, currentRound:value, modelState: ModelState.success));
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  RoundModel getCurrentRound() =>
      state.rounds.where((element) => element.activeRound && element.roundNumber == state.currentRoundNumber).first;
}
