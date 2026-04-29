import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/login/data/api/login_api.dart';
import 'package:work_hu/features/login/data/repository/login_repository.dart';
import 'package:work_hu/features/login/data/state/login_state.dart';
import 'package:work_hu/features/utils.dart';

final loginApiProvider = Provider<LoginApi>((ref) => LoginApi());

final loginRepoProvider = Provider<LoginRepository>((ref) => LoginRepository(ref.read(loginApiProvider)));

final loginDataProvider =
    StateNotifierProvider.autoDispose<LoginDataNotifier, LoginState>((ref) => LoginDataNotifier(ref.read(loginRepoProvider)));

class LoginDataNotifier extends BaseDataNotifier<LoginState> {
  LoginDataNotifier(this._loginRepository) : super(const LoginState()) {
    initGoogleWeb();
  }

  final LoginRepository _loginRepository;
  final UserProvider userProvider = locator<UserProvider>();

  @override
  LoginState copyWithStatus(BaseState status) {
    return state = state.copyWith(status: status);
  }

  Future<void> login({required String usr, required String pswd}) async {
    executeApiCall<Map<String, dynamic>>(() => _loginRepository.login(usr.trim(), pswd.trim()), onSuccess: (data) async {
      await Utils.saveData("jwt_token", data['token']);
      userProvider.setToken(data['token']);
      executeApiCall(() => _loginRepository.getUserByUsername(data['username']).then((userData) async {
            userProvider.setUser(userData);
          }));
    });
  }

  Future<void> signInWithGoogle(String idToken) async {
    try {
      executeApiCall<Map<String, dynamic>>(() => _loginRepository.loginWithGoogle(idToken), onSuccess: (data) async {
        userProvider.setToken(data['token']);
        executeApiCall(() => _loginRepository.getUserByUsername(data['username']).then((userData) async {
              userProvider.setUser(userData);
            }));
      });

      // 4. Handle your JWT response exactly like normal login
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
  }

  void initGoogleWeb() {
    final signIn = GoogleSignIn.instance;

    signIn
        .initialize(
      clientId: "470140408680-vvsu3rjroghr7suq603r4eek5lec5bds.apps.googleusercontent.com",
    )
        .then((_) {
      signIn.authenticationEvents.listen((event) async {
        if (event is GoogleSignInAuthenticationEventSignIn) {
          // Get the ID Token to send to your Java Backend
          final auth = event.user.authentication;
          final String? idToken = auth.idToken;

          if (idToken != null) {
            await signInWithGoogle(idToken);
          }
        } else if (event is GoogleSignInAuthenticationEventSignOut) {}
      });
    });
  }
}
