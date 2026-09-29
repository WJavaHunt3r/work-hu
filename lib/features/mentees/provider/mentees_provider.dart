import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/mentees/data/state/mentees_state.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';
import 'package:work_hu/features/mentor_mentee/data/repository/mentor_mentee_repository.dart';
import 'package:work_hu/features/mentor_mentee/provider/mentor_mentee_provider.dart';
import 'package:work_hu/features/user_rounds/data/repository/user_round_repository.dart';
import 'package:work_hu/features/user_rounds/providers/user_rounds_provider.dart';
import 'package:work_hu/features/user_status/data/repository/user_status_repository.dart';
import 'package:work_hu/features/user_status/providers/user_status_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

final menteesDataProvider = StateNotifierProvider.autoDispose<MenteesDataNotifier, MenteesState>(
  (ref) => MenteesDataNotifier(
    ref.read(userRoundsRepoProvider),
    ref.read(userStatusRepoProvider),
    ref.read(usersRepoProvider),
    ref.read(mentorMenteeRepoProvider),
    ref.read(userDataProvider).user,
  ),
);

class MenteesDataNotifier extends BaseDataNotifier<MenteesState> implements ListApiProvider {
  MenteesDataNotifier(
    this.userRoundRepository,
    this.userStatusRepoProvider,
    this.usersRepository,
    this.menteesRepository,
    this.currentUser,
  ) : super(const MenteesState()) {
    list();
  }

  final UserRoundRepository userRoundRepository;
  final UserStatusRepository userStatusRepoProvider;
  final UsersRepository usersRepository;
  final MentorMenteeRepository menteesRepository;
  final UserModel? currentUser;

  @override
  Future<void> list({filter, int? page, int? size, List<String>? sort}) async {
    await executeApiCall<List<UserGoalUserRoundModel>>(
      _fetchMenteeStatuses,
      background: true,
      onSuccess: (menteesStatus) async {
        state = state.copyWith(
          menteesStatus: menteesStatus,
          listState: state.listState.copyWith(number: 0, totalPages: 1, totalElements: menteesStatus.length),
        );
      },
    );
  }

  Future<List<UserGoalUserRoundModel>> _fetchMenteeStatuses() async {
    var year = DateTime.now().year;
    var mentees = await menteesRepository.getMentorMentee(userId: currentUser!.id);
    List<UserGoalUserRoundModel> list = [];
    for (var mentee in mentees) {
      var userRounds = await userRoundRepository.fetchUserRounds(userId: mentee.mentee.id, seasonYear: year);
      var userStatus = await userStatusRepoProvider.getUserStatusByUserId(mentee.mentee.id, year);
      userRounds.sort((a, b) => a.round.roundNumber.compareTo(b.round.roundNumber));
      list.add(UserGoalUserRoundModel(userStatus: userStatus, round: userRounds.last.round));
    }
    return list;
  }

  @override
  MenteesState copyWithState(BaseState status) {
    return state.copyWith(listState: state.listState.copyWith(baseStatus: status));
  }
}
