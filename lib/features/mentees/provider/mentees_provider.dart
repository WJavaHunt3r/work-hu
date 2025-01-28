import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/goal/data/repository/goal_repository.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/mentees/data/state/mentees_state.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';
import 'package:work_hu/features/mentor_mentee/data/repository/mentor_mentee_repository.dart';
import 'package:work_hu/features/mentor_mentee/provider/mentor_mentee_provider.dart';
import 'package:work_hu/features/profile/data/repository/user_round_repository.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/user_status/data/repository/user_status_repository.dart';
import 'package:work_hu/features/user_status/providers/user_status_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

final menteesDataProvider =
    StateNotifierProvider.autoDispose<MenteesDataNotifier, MenteesState>(
        (ref) => MenteesDataNotifier(
            ref.read(userRoundsRepoProvider),
            ref.read(userStatusRepoProvider),
            ref.read(usersRepoProvider),
            ref.read(mentorMenteeRepoProvider),
            ref.read(userDataProvider)));

class MenteesDataNotifier extends StateNotifier<MenteesState> {
  MenteesDataNotifier(this.userRoundRepository, this.userStatusRepoProvider,
      this.usersRepository, this.menteesRepository, this.currentUser)
      : super(const MenteesState()) {
    getMentees();
  }

  final UserRoundRepository userRoundRepository;
  final UserStatusRepository userStatusRepoProvider;
  final UsersRepository usersRepository;
  final MentorMenteeRepository menteesRepository;
  final UserModel? currentUser;

  Future<void> getMentees() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await menteesRepository
          .getMentorMentee(userId: currentUser!.id)
          .then((mentees) async {
        List<UserGoalUserRoundModel> list = [];
        for (var mentee in mentees) {
          await userRoundRepository
              .fetchUserRounds(
                  userId: mentee.mentee.id, seasonYear: DateTime.now().year)
              .then((userRounds) async {
            await userStatusRepoProvider
                .getUserStatusByUserId(mentee.mentee.id, DateTime.now().year)
                .then((userStatus) async {
              userRounds.sort(
                  (a, b) => a.round.roundNumber.compareTo(b.round.roundNumber));
              list.add(UserGoalUserRoundModel(
                  userStatus: userStatus, round: userRounds.last.round));
            });
          });
        }
        state =
            state.copyWith(menteesStatus: list, modelState: ModelState.success);
      });
    } catch (e) {
      state =
          state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }
}
