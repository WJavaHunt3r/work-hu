import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/goal/data/repository/goal_repository.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/login/data/repository/login_repository.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';
import 'package:work_hu/features/profile/data/api/user_round_api.dart';
import 'package:work_hu/features/profile/data/model/user_round_model.dart';
import 'package:work_hu/features/profile/data/repository/user_round_repository.dart';
import 'package:work_hu/features/profile/data/state/profile_state.dart';
import 'package:work_hu/features/user_fra_kare_week/data/repository/user_fra_kare_week_repository.dart';
import 'package:work_hu/features/user_fra_kare_week/provider/user_fra_kare_week_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

final userRoundsApiProvider = Provider<UserRoundApi>((ref) => UserRoundApi());

final userRoundsRepoProvider =
    Provider<UserRoundRepository>((ref) => UserRoundRepository(ref.read(userRoundsApiProvider)));

final profileDataProvider = StateNotifierProvider.autoDispose<ProfileDataNotifier, ProfileState>((ref) =>
    ProfileDataNotifier(
        ref.read(loginRepoProvider),
        ref.read(userDataProvider.notifier),
        ref.read(userRoundsRepoProvider),
        ref.read(goalRepoProvider),
        ref.read(usersRepoProvider),
        ref.read(userFraKareWeekRepoProvider)));

class ProfileDataNotifier extends StateNotifier<ProfileState> {
  ProfileDataNotifier(
    this.loginRepository,
    this.currentUser,
    this.userRoundRepoProvider,
    this.goalRepoProvider,
    this.usersRepository,
    this.userFraKareWeekRepo,
  ) : super(const ProfileState()) {
    getUserInfo();
  }

  final UserDataNotifier currentUser;
  final LoginRepository loginRepository;
  final UserRoundRepository userRoundRepoProvider;
  final GoalRepository goalRepoProvider;
  final UsersRepository usersRepository;
  final UserFraKareWeekRepository userFraKareWeekRepo;

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
      await userFraKareWeekRepo.getFraKareWeeks(userId: userModel.id).then((data) {
        data.sort((a, b) => b.fraKareWeek.weekNumber.compareTo(a.fraKareWeek.weekNumber));
        state = state.copyWith(fraKareWeeks: data);
      });
      await loginRepository.getUser(userModel.id).then((userData) async {
        if (userData.changedPassword) {
          currentUser.setUser(userData);
        }
      });
      if (userModel.spouseId != null) {
        await usersRepository.getUserById(userModel.spouseId!).then((value) => state = state.copyWith(spouse: value));
      }
      userRoundRepoProvider
          .fetchUserRounds(userId: userModel.id, seasonYear: DateTime.now().year)
          .then((userRounds) async {
        if (userRounds.isNotEmpty) {
          userRounds.sort((a, b) => a.round.roundNumber.compareTo(b.round.roundNumber));
          var points = <num>[];
          for (var i = 1; i <= 5; i++) {
            points.add(userRounds.isNotEmpty
                ? userRounds
                    .firstWhere((e) => e.round.activeRound && e.round.roundNumber == i,
                        orElse: () => userRounds.first.copyWith(roundCoins: 0))
                    .roundCoins
                : 0);
          }
          state = state.copyWith(roundPoints: points);
          await goalRepoProvider.getGoalByUserAndSeason(userModel.id, DateTime.now().year).then((goal) async {
            state = state.copyWith(
                userGoal: goal,
                userRounds:
                    userRounds.where((element) => element.round.startDateTime.compareTo(DateTime.now()) < 0).toList());
          });
        }
      });

      usersRepository.getChildren(userModel.id).then((children) async {
        state = state.copyWith(children: children, childrenUserRounds: [], childrenGoals: []);
        for (var child in children) {
          await userRoundRepoProvider
              .fetchUserRounds(userId: child.id, seasonYear: DateTime.now().year)
              .then((userRounds) async {
            if (userRounds.isNotEmpty) {
              userRounds.sort((a, b) => a.round.roundNumber.compareTo(b.round.roundNumber));
              await goalRepoProvider.getGoalByUserAndSeason(child.id, DateTime.now().year).then((goal) async {
                var childrenRounds = <UserRoundModel>[
                  ...state.childrenUserRounds,
                  ...userRounds.where((element) => element.round.startDateTime.compareTo(DateTime.now()) < 0)
                ];
                var childrenGoals = [...state.childrenGoals, goal];
                state = state.copyWith(childrenGoals: childrenGoals, childrenUserRounds: childrenRounds);
              });
            }
          });
        }
      });
    }
  }

  Future<void> logout() async {
    await Utils.saveData("user", "");
    await Utils.saveData("password", "");

    currentUser.setUser(null);
  }

  Future<void> getUserGoal() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await goalRepoProvider
          .getGoalByUserAndSeason(currentUser.state!.id, DateTime.now().year)
          .then((goal) => state = state.copyWith(userGoal: goal, modelState: ModelState.success));
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }
}
