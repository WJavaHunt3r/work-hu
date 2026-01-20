import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/repository/login_repository.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';
import 'package:work_hu/features/profile/data/api/user_round_api.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/profile/data/repository/user_round_repository.dart';
import 'package:work_hu/features/profile/data/state/profile_state.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/user_fra_kare_week/data/repository/user_fra_kare_week_repository.dart';
import 'package:work_hu/features/user_fra_kare_week/provider/user_fra_kare_week_provider.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';
import 'package:work_hu/features/user_status/data/repository/user_status_repository.dart';
import 'package:work_hu/features/user_status/providers/user_status_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

final userRoundsApiProvider = Provider<UserRoundApi>((ref) => UserRoundApi());

final userRoundsRepoProvider = Provider<UserRoundRepository>((ref) => UserRoundRepository(ref.read(userRoundsApiProvider)));

final profileDataProvider = StateNotifierProvider.autoDispose<ProfileDataNotifier, ProfileState>((ref) => ProfileDataNotifier(
    ref.read(loginRepoProvider),
    ref.read(userDataProvider.notifier),
    ref.read(userRoundsRepoProvider),
    ref.read(userStatusRepoProvider),
    ref.read(usersRepoProvider),
    ref.read(userFraKareWeekRepoProvider),
    ref.read(roundDataProvider.notifier)));

class ProfileDataNotifier extends StateNotifier<ProfileState> {
  ProfileDataNotifier(
    this.loginRepository,
    this.currentUser,
    this.userRoundRepoProvider,
    this.userStatusRepoProvider,
    this.usersRepository,
    this.userFraKareWeekRepo,
    this.roundDataNotifier,
  ) : super(const ProfileState()) {
    getUserInfo();
  }

  final UserDataNotifier currentUser;
  final LoginRepository loginRepository;
  final UserRoundRepository userRoundRepoProvider;
  final UserStatusRepository userStatusRepoProvider;
  final UsersRepository usersRepository;
  final UserFraKareWeekRepository userFraKareWeekRepo;
  final RoundDataNotifier roundDataNotifier;

  Future<void> getUserInfo() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await getUserInfoAndUserRounds().then((value) => state = state.copyWith(modelState: ModelState.success));
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<void> getUserInfoAndUserRounds() async {
    var userModel = currentUser.state;

    if (userModel != null) {
      await userFraKareWeekRepo.getFraKareWeeks(userId: userModel.id, year: DateTime.now().year).then((data) {
        data.sort((a, b) => b.fraKareWeek.weekNumber.compareTo(a.fraKareWeek.weekNumber));
        state = state.copyWith(fraKareWeeks: data);
      });
      await loginRepository.getUser(userModel.id).then((userData) async {
        if (userData.changedPassword) {
          currentUser.setUser(userData);
        }
      });
      getUserRound(userModel.id).then((userRounds) async {
        if (userRounds.isNotEmpty && userRounds.length == 1) {
          await getUserStatus(userModel.id).then((userStatus) async {
            state = state.copyWith(statuses: [userStatus], userRounds: [userRounds.first]);
          });
        }
      });
      if (userModel.spouseId != null) {
        usersRepository.getUserById(userModel.spouseId!).then((value) async {
          state = state.copyWith(spouse: value);
          await getUserRound(value.id).then((userRounds) async {
            if (userRounds.isNotEmpty && userRounds.length == 1) {
              await getUserStatus(value.id).then((status) async {
                state = state.copyWith(statuses: [...state.statuses, status], userRounds: [...state.userRounds, userRounds[0]]);
              });
            }
          });
        });
      }

      usersRepository.getChildren(userModel.id).then((children) async {
        state = state.copyWith(children: children);
        for (var child in children) {
          await getUserRound(child.id).then((userRounds) async {
            if (userRounds.isNotEmpty && userRounds.length == 1) {
              await getUserStatus(child.id).then((status) async {
                state = state.copyWith(statuses: [...state.statuses, status], userRounds: [...state.userRounds, userRounds[0]]);
              });
            }
          });
        }
      });
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
    await Utils.saveData("user", "");
    await Utils.saveData("password", "");

    currentUser.setUser(null);
  }
}
