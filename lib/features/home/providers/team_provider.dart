import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/donation/data/repository/donation_repository.dart';
import 'package:work_hu/features/donation/providers/donation_provider.dart';
import 'package:work_hu/features/home/data/api/team_round_api.dart';
import 'package:work_hu/features/home/data/repository/team_round_repository.dart';
import 'package:work_hu/features/home/data/state/team_round_state.dart';
import 'package:work_hu/features/teams/data/repository/teams_repository.dart';
import 'package:work_hu/features/teams/provider/teams_provider.dart';

final teamApiProvider = Provider<TeamRoundApi>((ref) => TeamRoundApi());

final teamRepoProvider = Provider<TeamRoundRepository>((ref) => TeamRoundRepository(ref.read(teamApiProvider)));

final teamRoundDataProvider = StateNotifierProvider.autoDispose<TeamRoundDataNotifier, TeamRoundState>(
    (ref) => TeamRoundDataNotifier(ref.read(teamsRepoProvider), ref.read(donationRepoProvider)));

class TeamRoundDataNotifier extends StateNotifier<TeamRoundState> {
  TeamRoundDataNotifier(this.teamRepository, this.donationRepository) : super(const TeamRoundState()) {
    getTeamRounds().then((value) async => await getDonations());
  }

  final TeamRepository teamRepository;
  final DonationRepository donationRepository;

  Future<void> getTeamRounds() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await teamRepository.fetchTeams().then((data) async {
        state = state.copyWith(teams: data, modelState: ModelState.success);
      });
    } catch (e) {
      state = state.copyWith(modelState: ModelState.error);
    }
  }

  Future<void> checkLoginCredentials() async {
    await getTeamRounds();
    // state = state.copyWith(modelState: ModelState.processing);
    // var username = await Utils.getData('user');
    // var password = await Utils.getData('password');
    //
    // var user = userSessionProvider.state;
    // if (username.isNotEmpty && password.isNotEmpty && user == null) {
    //   //state = state.copyWith(modelState: ModelState.processing);
    //   read.state = LoginState(username: username, password: password);
    //   // await read.login();
    //   state = state.copyWith(message: read.state.message, modelState: ModelState.success);
    // } else {
    //   if (user == null && username.isNotEmpty) {
    //     await loginRepository.getUser(username).then((value) => userSessionProvider.setUser(value));
    //   }
    //   state = state.copyWith(modelState: ModelState.success);
    // }
  }

  Future<void> getDonations() async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await donationRepository.getDonations(DateTime.now()).then((donations) {
        donations.sort((a, b) => b.endDateTime!.compareTo(a.endDateTime!));
        state = state.copyWith(donations: donations, modelState: ModelState.success);
      });
    } on DioException {
      state = state.copyWith(modelState: ModelState.error, message: "Failed to fetch donations ");
    }
  }
}
