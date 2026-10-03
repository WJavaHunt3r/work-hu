import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/mentees/data/state/user_goal_user_round_model.dart';
import 'package:work_hu/features/mentor_mentee/data/repository/mentor_mentee_repository.dart';
import 'package:work_hu/features/mentor_mentee/provider/mentor_mentee_provider.dart';
import 'package:work_hu/features/user_rounds/data/repository/user_round_repository.dart';
import 'package:work_hu/features/user_rounds/providers/user_rounds_provider.dart';
import 'package:work_hu/features/user_status/data/repository/user_status_repository.dart';
import 'package:work_hu/features/user_status/providers/user_status_provider.dart';

/// The current user's mentees with their status.
final menteesDataProvider =
    StateNotifierProvider.autoDispose<MenteesDataNotifier, PagedState<UserGoalUserRoundModel, num>>(
      (ref) => MenteesDataNotifier(
        ref.read(userRoundsRepoProvider),
        ref.read(userStatusRepoProvider),
        ref.read(mentorMenteeRepoProvider),
        ref.read(userDataProvider).user!.id,
      ),
    );

class MenteesDataNotifier extends PagedListNotifier<UserGoalUserRoundModel, num> {
  MenteesDataNotifier(this.userRoundRepository, this.userStatusRepository, this.menteesRepository, num mentorId)
    : super(ListQuery(filter: mentorId));

  final UserRoundRepository userRoundRepository;
  final UserStatusRepository userStatusRepository;
  final MentorMenteeRepository menteesRepository;

  /// Not paged: builds every mentee's status for the current season.
  @override
  Future<PaginatedResponse<UserGoalUserRoundModel>> fetch(ListQuery<num> query, int page) async {
    var year = DateTime.now().year;
    var mentees = await menteesRepository.getMentorMentee(userId: query.filter);
    List<UserGoalUserRoundModel> list = [];
    for (var mentee in mentees) {
      var userRounds = await userRoundRepository.fetchUserRounds(userId: mentee.mentee.id, seasonYear: year);
      var userStatus = await userStatusRepository.getUserStatusByUserId(mentee.mentee.id, year);
      userRounds.sort((a, b) => a.round.roundNumber.compareTo(b.round.roundNumber));
      list.add(UserGoalUserRoundModel(userStatus: userStatus, round: userRounds.last.round));
    }
    return PaginatedResponse.all(list);
  }
}
