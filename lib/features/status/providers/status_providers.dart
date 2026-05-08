import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/profile/data/state/profile_state.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/status/data/state/status_state.dart';
import 'package:work_hu/features/user_rounds/data/model/user_round_model.dart';
import 'package:work_hu/features/user_rounds/data/repository/user_round_repository.dart';
import 'package:work_hu/features/user_rounds/providers/user_rounds_provider.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/user_status/data/repository/user_status_repository.dart';
import 'package:work_hu/features/user_status/providers/user_status_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

import '../../../app/providers/base_provider.dart';

final statusDataProvider = StateNotifierProvider.autoDispose<StatusDataNotifier, StatusState>((ref) => StatusDataNotifier(
    ref.read(userDataProvider.notifier),
    ref.read(userRoundsRepoProvider),
    ref.read(userStatusRepoProvider),
    ref.read(usersRepoProvider),
    ref.read(roundDataProvider.notifier)));

class StatusDataNotifier extends BaseDataNotifier<StatusState> {
  StatusDataNotifier(
    this.currentUser,
    this.userRoundRepoProvider,
    this.userStatusRepoProvider,
    this.usersRepository,
    this.roundDataNotifier,
  ) : super(const StatusState());

  final UserProvider currentUser;
  final UserRoundRepository userRoundRepoProvider;
  final UserStatusRepository userStatusRepoProvider;
  final UsersRepository usersRepository;
  final RoundDataNotifier roundDataNotifier;

  Future<void> getUserInfo() async {
    // await executeApiCall(()=> getUserInfoAndUserRounds());
  }

  Future<void> getUserInfoAndUserRounds() async {
    var userModel = currentUser.user;

    if (userModel != null) {
      // await userFraKareWeekRepo.getFraKareWeeks(userId: userModel.id, year: DateTime.now().year).then((data) {
      //   data.sort((a, b) => b.fraKareWeek.weekNumber.compareTo(a.fraKareWeek.weekNumber));
      //   state = state.copyWith(fraKareWeeks: data);
      // });
      getUserRound(userModel.id).then((userRounds) async {
        if (userRounds.isNotEmpty && userRounds.length == 1) {
          await getUserStatus(userModel.id).then((userStatus) async {
            state = state.copyWith(statuses: [userStatus], userRounds: [userRounds.first]);
          });
        }
      });
      // if (userModel.spouseId != null) {
      //   usersRepository.getUserById(userModel.spouseId!).then((value) async {
      //     state = state.copyWith(spouse: value);
      //     await getUserRound(value.id).then((userRounds) async {
      //       if (userRounds.isNotEmpty && userRounds.length == 1) {
      //         await getUserStatus(value.id).then((status) async {
      //           state = state.copyWith(statuses: [...state.statuses, status], userRounds: [...state.userRounds, userRounds[0]]);
      //         });
      //       }
      //     });
      //   });
      // }

      // usersRepository.getChildren(userModel.id).then((children) async {
      //   state = state.copyWith(children: children);
      //   for (var child in children) {
      //     await getUserRound(child.id).then((userRounds) async {
      //       if (userRounds.isNotEmpty && userRounds.length == 1) {
      //         await getUserStatus(child.id).then((status) async {
      //           state = state.copyWith(statuses: [...state.statuses, status], userRounds: [...state.userRounds, userRounds[0]]);
      //         });
      //       }
      //     });
      //   }
      // });
    }
  }

  Future<List<UserRoundModel>> getUserRound(num id) async {
    return await userRoundRepoProvider.fetchUserRounds(
        userId: id, seasonYear: DateTime.now().year, roundId: roundDataNotifier.getCurrentRound()!.id);
  }

  Future<UserStatusModel> getUserStatus(num id) async {
    return await userStatusRepoProvider.getUserStatusByUserId(id, DateTime.now().year);
  }

  Future<void> logout() async {
    var googleAuth = GoogleSignIn.instance;
    googleAuth.disconnect();
    currentUser.setToken(null);
    currentUser.setUser(null);
  }

  @override
  StatusState copyWithState(BaseState status) {
    return state.copyWith(status: status);
  }
}
