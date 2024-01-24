import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/features/season/data/api/season_api.dart';
import 'package:work_hu/features/season/data/repository/season_repository.dart';
import 'package:work_hu/features/season/data/state/season_state.dart';

final seasonApiProvider = Provider<SeasonApi>((ref) => SeasonApi());

final seasonRepoProvider = Provider<SeasonRepository>((ref) => SeasonRepository(ref.read(seasonApiProvider)));

final seasonDataProvider =
    StateNotifierProvider<SeasonDataNotifier, SeasonState>((ref) => SeasonDataNotifier(ref.read(seasonRepoProvider)));

class SeasonDataNotifier extends StateNotifier<SeasonState> {
  SeasonDataNotifier(
    this.seasonRepository,
  ) : super(const SeasonState());

  final SeasonRepository seasonRepository;
}
