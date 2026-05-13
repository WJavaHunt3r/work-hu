import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
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
  ) : super(const StatusState()) {
    getUserInfoAndUserRounds();
  }

  final UserProvider currentUser;
  final UserRoundRepository userRoundRepoProvider;
  final UserStatusRepository userStatusRepoProvider;
  final UsersRepository usersRepository;
  final RoundDataNotifier roundDataNotifier;

  Future<void> getUserInfo() async {
    // await executeApiCall(()=> getUserInfoAndUserRounds());
  }

  Future<void> getUserInfoAndUserRounds() async {
    // roundDataNotifier.getCurrentRound();
    var userModel = currentUser.user;

    if (userModel != null) {
      executeApiCall<UserStatusModel>(() => getUserStatus(userModel.id), onSuccess: (userRounds) async {
        state = state.copyWith(statuses: [userRounds]);
      });

      executeApiCall<List<UserModel>>(() => usersRepository.getChildren(userModel.id), onSuccess: (children) async {
        state = state.copyWith(children: children);
        for (var child in children) {
          await getUserStatus(child.id).then((status) async {
            state = state.copyWith(statuses: [...state.statuses, status]);
          });
        }
      });
    }
  }

  Future<List<UserRoundModel>> getUserRounds(num id) async {
    return userRoundRepoProvider.fetchUserRounds(userId: id, seasonYear: DateTime.now().year);
  }

  Future<UserStatusModel> getUserStatus(num id) async {
    return await userStatusRepoProvider.getUserStatusByUserId(id, DateTime.now().year);
  }

  @override
  StatusState copyWithState(BaseState status) {
    return state.copyWith(status: status);
  }
}
