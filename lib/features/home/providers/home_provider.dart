import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/home/data/state/home_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/login/data/repository/login_repository.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';

final homeDataProvider =
    StateNotifierProvider.autoDispose<HomeDataNotifier, HomeState>((ref) => HomeDataNotifier(ref.watch(loginRepoProvider)));

class HomeDataNotifier extends BaseDataNotifier<HomeState> {
  HomeDataNotifier(this._loginRepository) : super(const HomeState());

  final LoginRepository _loginRepository;
  final UserProvider userProvider = locator<UserProvider>();

  @override
  HomeState copyWithStatus(BaseState status) {
    return state = state.copyWith(status: status);
  }

  Future<void> login({required String usr, required String pswd}) async {
    executeApiCall<Map<String, dynamic>>(() => _loginRepository.login(usr, pswd),
        onSuccess: (data) => executeApiCall(() => _loginRepository.getUserByUsername(data['username']).then((userData) async {
              userProvider.setUser(userData);
            })));
  }
}
