import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/list_api_provider.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/goal/data/repository/goal_repository.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/mentor_mentee/data/api/mentor_mentee_api.dart';
import 'package:work_hu/features/mentor_mentee/data/model/mentor_mentee_model.dart';
import 'package:work_hu/features/mentor_mentee/data/repository/mentor_mentee_repository.dart';
import 'package:work_hu/features/mentor_mentee/data/state/mentor_mentee_state.dart';
import 'package:work_hu/features/user_rounds/data/repository/user_round_repository.dart';
import 'package:work_hu/features/user_rounds/providers/user_rounds_provider.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

final mentorMenteeApiProvider = Provider<MentorMenteeApi>((ref) => MentorMenteeApi());

final mentorMenteeRepoProvider = Provider<MentorMenteeRepository>(
  (ref) => MentorMenteeRepository(ref.read(mentorMenteeApiProvider)),
);

final mentorMenteeDataProvider = StateNotifierProvider.autoDispose<MentorMenteeDataNotifier, MentorMenteeState>(
  (ref) => MentorMenteeDataNotifier(
    ref.read(userRoundsRepoProvider),
    ref.read(goalRepoProvider),
    ref.read(usersRepoProvider),
    ref.read(mentorMenteeRepoProvider),
    ref.read(userDataProvider).user,
  ),
);

class MentorMenteeDataNotifier extends BaseDataNotifier<MentorMenteeState> implements ListApiProvider {
  MentorMenteeDataNotifier(
    this.userRoundRepository,
    this.goalRepoProvider,
    this.usersRepository,
    this.menteesRepository,
    this.currentUser,
  ) : super(const MentorMenteeState()) {
    mentorController = TextEditingController(text: "");
    menteeController = TextEditingController(text: "");
    list().then((_) => getUsers());
  }

  final UserRoundRepository userRoundRepository;
  final GoalRepository goalRepoProvider;
  final UsersRepository usersRepository;
  final MentorMenteeRepository menteesRepository;
  final UserModel? currentUser;
  late final TextEditingController mentorController;
  late final TextEditingController menteeController;

  @override
  Future<void> list({filter, int? page, int? size, List<String>? sort}) async {
    await executeApiCall<List<MentorMenteeModel>>(
      () => menteesRepository.getMentorMentee(),
      background: true,
      onSuccess: (mentees) async {
        state = state.copyWith(
          mentees: mentees,
          listState: state.listState.copyWith(number: 0, totalPages: 1, totalElements: mentees.length),
        );
      },
    );
  }

  Future<void> postMentee() async {
    await executeApiCall<MentorMenteeModel>(
      () => menteesRepository.postMentee(
        MentorMenteeModel(mentor: state.mentor!, mentee: state.mentee!),
        currentUser!.id,
      ),
      onSuccess: (_) async {
        clearCreation();
        list(page: 0);
      },
    );
  }

  Future<void> deleteMentee(num id) async {
    var origItems = state.mentees;
    var origListState = state.listState;
    state = state.copyWith(
      mentees: origItems.where((m) => m.id != id).toList(),
      listState: origListState.copyWith(totalElements: origListState.totalElements - 1),
    );
    await executeApiCall<String>(
      () => menteesRepository.deleteMentee(id, currentUser!.id),
      onError: (error) async {
        state = state.copyWith(
          mentees: origItems,
          listState: state.listState.copyWith(totalElements: origListState.totalElements),
        );
      },
    );
  }

  Future<void> getUsers() async {
    await executeApiCall<List<UserModel>>(
      () => usersRepository.getUsers(null, false),
      background: true,
      onSuccess: (users) async {
        state = state.copyWith(createState: ModelState.empty, users: users);
      },
    );
  }

  Future<List<UserModel>> filterUsers(String filter) async {
    var filtered = state.users
        .where(
          (u) =>
              Utils.changeSpecChars(
                u.firstname.toLowerCase(),
              ).startsWith(Utils.changeSpecChars(filter.toLowerCase())) ||
              Utils.changeSpecChars(u.lastname.toLowerCase()).startsWith(Utils.changeSpecChars(filter.toLowerCase())),
        )
        .toList();
    filtered.sort((a, b) => (a.getFullName()).compareTo(b.getFullName()));
    return filtered;
  }

  updateSelection({UserModel? mentor, UserModel? mentee}) {
    if (mentor != null) {
      mentorController.text = "${mentor.getFullName()} ( ${mentor.getAge()}) ";
    }
    if (mentee != null) {
      menteeController.text = "${mentee.getFullName()} ( ${mentee.getAge()}) ";
    }
    state = state.copyWith(mentor: mentor ?? state.mentor, mentee: mentee ?? state.mentee);
  }

  clearCreation() {
    menteeController.text = "";
    mentorController.text = "";
    state = state.copyWith(mentor: null, mentee: null, createState: ModelState.empty);
  }

  @override
  MentorMenteeState copyWithState(BaseState status) {
    return state.copyWith(listState: state.listState.copyWith(baseStatus: status));
  }
}
