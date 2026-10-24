import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/features/season/data/model/season_model.dart';
import 'package:work_hu/features/season/provider/season_provider.dart';

/// All seasons, for the round form's season picker.
final seasonsListProvider = FutureProvider.autoDispose<List<SeasonModel>>(
  (ref) => ref.read(seasonRepoProvider).getSeasons(),
);
