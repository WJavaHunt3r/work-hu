import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/features/user_rounds/data/api/user_round_api.dart';
import 'package:work_hu/features/user_rounds/data/repository/user_round_repository.dart';

final userRoundsApiProvider = Provider<UserRoundApi>((ref) => UserRoundApi());

final userRoundsRepoProvider = Provider<UserRoundRepository>((ref) => UserRoundRepository(ref.read(userRoundsApiProvider)));