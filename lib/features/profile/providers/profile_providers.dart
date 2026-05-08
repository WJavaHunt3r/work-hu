import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/repository/login_repository.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';
import 'package:work_hu/features/profile/data/state/profile_state.dart';

import '../../../app/providers/base_provider.dart';

final profileDataProvider = StateNotifierProvider.autoDispose<ProfileDataNotifier, ProfileState>((ref) => ProfileDataNotifier(
      ref.read(loginRepoProvider),
      ref.read(userDataProvider.notifier),
    ));

class ProfileDataNotifier extends BaseDataNotifier<ProfileState> {
  ProfileDataNotifier(
    this.loginRepository,
    this.currentUser,
  ) : super(const ProfileState());

  final UserProvider currentUser;
  final LoginRepository loginRepository;

  Future<void> logout() async {
    var googleAuth = GoogleSignIn.instance;
    googleAuth.disconnect();
    currentUser.setToken(null);
    currentUser.setUser(null);
  }

  @override
  ProfileState copyWithState(BaseState status) {
    return state.copyWith(status: status);
  }
}
