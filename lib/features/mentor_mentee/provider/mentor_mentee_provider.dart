import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/goal/data/repository/goal_repository.dart';
import 'package:work_hu/features/goal/provider/goal_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/mentor_mentee/data/api/mentor_mentee_api.dart';
import 'package:work_hu/features/mentor_mentee/data/model/mentor_mentee_model.dart';
import 'package:work_hu/features/mentor_mentee/data/repository/mentor_mentee_repository.dart';
import 'package:work_hu/features/mentor_mentee/data/state/mentor_mentee_state.dart';
import 'package:work_hu/features/profile/data/repository/user_round_repository.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

final mentorMenteeApiProvider = Provider<MentorMenteeApi>((ref) => MentorMenteeApi());

final mentorMenteeRepoProvider = Provider<MentorMenteeRepository>((ref) => MentorMenteeRepository(ref.read(mentorMenteeApiProvider)));

final mentorMenteeDataProvider = StateNotifierProvider.autoDispose<MentorMenteeDataNotifier, MentorMenteeState>((ref) =>
    MentorMenteeDataNotifier(ref.read(userRoundsRepoProvider), ref.read(goalRepoProvider), ref.read(usersRepoProvider),
        ref.read(mentorMenteeRepoProvider), ref.read(userDataProvider)));

class MentorMenteeDataNotifier extends StateNotifier<MentorMenteeState> {
  MentorMenteeDataNotifier(
      this.userRoundRepository, this.goalRepoProvider, this.usersRepository, this.menteesRepository, this.currentUser)
      : super(const MentorMenteeState()) {
    getUsers();
    getMentorMentee();
    mentorController = TextEditingController(text: "");
    menteeController = TextEditingController(text: "");
  }

  final UserRoundRepository userRoundRepository;
  final GoalRepository goalRepoProvider;
  final UsersRepository usersRepository;
  final MentorMenteeRepository menteesRepository;
  final UserModel? currentUser;
  late final TextEditingController mentorController;
  late final TextEditingController menteeController;

  Future<void> getMentorMentee() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await menteesRepository
          .getMentorMentee()
          .then((value) => state = state.copyWith(mentees: value, modelState: ModelState.success));
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> postMentee() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      var mentees = MentorMenteeModel(mentor: state.mentor!, mentee: state.mentee!);
      await menteesRepository.postMentee(mentees, currentUser!.id).then((value) {
        state = state.copyWith(message: "Mentor - Mentee successfully created!", createState: ModelState.success);
        getMentorMentee();
        clearCreation();
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString());
    }
  }

  Future<void> deleteMentee(num id) async {
    List<MentorMenteeModel> origItems = state.mentees;
    List<MentorMenteeModel> items = [];
    for (var a in origItems) {
      if (a.id != id) {
        items.add(a);
      }
    }
    state = state.copyWith(mentees: items, modelState: ModelState.processing);
    try {
      await menteesRepository.deleteMentee(id, currentUser!.id).then((value) {
        state = state.copyWith(
            message: "Mentor - Mentee successfully deleted!", modelState: ModelState.success, mentees: items);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.toString(), mentees: origItems);
    }
  }

  Future<void> getUsers() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await usersRepository.getUsers(null, false).then((data) {
        state = state.copyWith(
          modelState: ModelState.success,
          createState: ModelState.empty,
          users: data,
        );
      });
    } on DioError catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.message);
    }
  }

  Future<List<UserModel>> filterUsers(String filter) async {
    var filtered = state.users
        .where((u) =>
            Utils.changeSpecChars(u.firstname.toLowerCase()).startsWith(Utils.changeSpecChars(filter.toLowerCase())) ||
            Utils.changeSpecChars(u.lastname.toLowerCase()).startsWith(Utils.changeSpecChars(filter.toLowerCase())))
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
}
