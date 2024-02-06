import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/goal/data/repository/goal_repository.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/login/data/repository/login_repository.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';
import 'package:work_hu/features/profile/data/api/user_round_api.dart';
import 'package:work_hu/features/profile/data/repository/user_round_repository.dart';
import 'package:work_hu/features/profile/data/state/profile_state.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

final userRoundsApiProvider = Provider<UserRoundApi>((ref) => UserRoundApi());

final userRoundsRepoProvider =
    Provider<UserRoundRepository>((ref) => UserRoundRepository(ref.read(userRoundsApiProvider)));

final profileDataProvider = StateNotifierProvider.autoDispose<ProfileDataNotifier, ProfileState>((ref) =>
    ProfileDataNotifier(ref.read(loginRepoProvider), ref.read(userDataProvider.notifier),
        ref.read(userRoundsRepoProvider), ref.read(goalRepoProvider), ref.read(usersRepoProvider)));

class ProfileDataNotifier extends StateNotifier<ProfileState> {
  ProfileDataNotifier(
    this.loginRepository,
    this.read,
    this.userRoundRepoProvider,
    this.goalRepoProvider,
    this.usersRepository,
  ) : super(const ProfileState()) {
    getUserInfo();
  }

  final UserDataNotifier read;
  final LoginRepository loginRepository;
  final UserRoundRepository userRoundRepoProvider;
  final GoalRepository goalRepoProvider;
  final UsersRepository usersRepository;

  Future<void> getUserInfo() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await getUserInfoAndUserRounds().then((value) => state = state.copyWith(modelState: ModelState.success));
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<void> getUserInfoAndUserRounds() async {
    var user = await Utils.getData('user');
    await loginRepository.getUser(user).then((data) {
      read.setUser(data);
    });

    await userRoundRepoProvider.fetchUserRounds(userId: read.state!.id, seasonYear: 2024).then((userRounds) async {
      userRounds.sort((a, b) => a.round.roundNumber.compareTo(b.round.roundNumber));
      await goalRepoProvider.getGoalByUserAndSeason(read.state!.id, DateTime.now().year).then((goal) async {
        if (read.state!.spouseId != null) {
          await usersRepository.getUserById(read.state!.spouseId!).then((value) => state = state.copyWith(
              spouse: value,
              userGoal: goal,
              userRounds:
                  userRounds.where((element) => element.round.startDateTime.compareTo(DateTime.now()) < 0).toList()));
        } else {
          state = state.copyWith(
              userGoal: goal,
              userRounds:
                  userRounds.where((element) => element.round.startDateTime.compareTo(DateTime.now()) < 0).toList());
        }
      });
    });
  }

  Future<void> logout() async {
    await Utils.saveData("user", "");
    await Utils.saveData("password", "");

    read.setUser(null);
  }

  Future<void> getUserGoal() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await goalRepoProvider
          .getGoalByUserAndSeason(read.state!.id, DateTime.now().year)
          .then((goal) => state = state.copyWith(userGoal: goal, modelState: ModelState.success));
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }
}
