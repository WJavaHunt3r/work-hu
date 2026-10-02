import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/mentor_mentee/data/api/mentor_mentee_api.dart';
import 'package:work_hu/features/mentor_mentee/data/model/mentor_mentee_model.dart';
import 'package:work_hu/features/mentor_mentee/data/repository/mentor_mentee_repository.dart';
import 'package:work_hu/features/mentor_mentee/data/state/mentor_mentee_create_state.dart';
import 'package:work_hu/features/users/data/repository/users_repository.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';

final mentorMenteeApiProvider = Provider<MentorMenteeApi>((ref) => MentorMenteeApi());

final mentorMenteeRepoProvider = Provider<MentorMenteeRepository>(
  (ref) => MentorMenteeRepository(ref.read(mentorMenteeApiProvider)),
);

final mentorMenteeDataProvider =
    StateNotifierProvider.autoDispose<MentorMenteeDataNotifier, PagedState<MentorMenteeModel, void>>(
      (ref) => MentorMenteeDataNotifier(ref.read(mentorMenteeRepoProvider), ref.read(userDataProvider).user),
    );

final mentorMenteeCreateProvider =
    StateNotifierProvider.autoDispose<MentorMenteeCreateNotifier, MentorMenteeCreateState>(
      (ref) => MentorMenteeCreateNotifier(
        ref.read(usersRepoProvider),
        ref.read(mentorMenteeRepoProvider),
        ref.read(userDataProvider).user,
      ),
    );

class MentorMenteeDataNotifier extends PagedListNotifier<MentorMenteeModel, void> {
  MentorMenteeDataNotifier(this.menteesRepository, this.currentUser) : super(const ListQuery(filter: null));

  final MentorMenteeRepository menteesRepository;
  final UserModel? currentUser;

  /// Not paged by the server: returns every pair at once.
  @override
  Future<PaginatedResponse<MentorMenteeModel>> fetch(ListQuery<void> query, int page) async =>
      PaginatedResponse.all(await menteesRepository.getMentorMentee());

  Future<void> deleteMentee(num id) async {
    await executeApiCall<String>(
      () => menteesRepository.deleteMentee(id, currentUser!.id),
      onSuccess: (_) async => removeItems((m) => m.id == id),
    );
  }
}

/// The pair being created in the create dialog.
class MentorMenteeCreateNotifier extends BaseDataNotifier<MentorMenteeCreateState> {
  MentorMenteeCreateNotifier(this.usersRepository, this.menteesRepository, this.currentUser)
    : super(const MentorMenteeCreateState()) {
    getUsers();
  }

  final UsersRepository usersRepository;
  final MentorMenteeRepository menteesRepository;
  final UserModel? currentUser;
  final TextEditingController mentorController = TextEditingController(text: "");
  final TextEditingController menteeController = TextEditingController(text: "");

  /// Returns whether the pair was created.
  Future<bool> postMentee() async {
    final result = await executeApiCall<MentorMenteeModel>(
      () => menteesRepository.postMentee(
        MentorMenteeModel(mentor: state.mentor!, mentee: state.mentee!),
        currentUser!.id,
      ),
      onSuccess: (_) async => clearCreation(),
    );
    return result != null;
  }

  Future<void> getUsers() async {
    await executeApiCall<List<UserModel>>(
      () => usersRepository.getUsers(null, false),
      background: true,
      onSuccess: (users) async {
        state = state.copyWith(users: users);
      },
    );
  }

  // The user picker only knows the id; the pair needs the full user, which getUsers has loaded.
  void selectMentor(num userId) => state = state.copyWith(mentor: _userById(userId));

  void selectMentee(num userId) => state = state.copyWith(mentee: _userById(userId));

  UserModel? _userById(num id) => state.users.where((u) => u.id == id).firstOrNull;

  void clearCreation() {
    menteeController.text = "";
    mentorController.text = "";
    state = state.copyWith(mentor: null, mentee: null);
  }

  @override
  MentorMenteeCreateState copyWithState(BaseState status) => state.copyWith(status: status);

  @override
  void dispose() {
    mentorController.dispose();
    menteeController.dispose();
    super.dispose();
  }
}
