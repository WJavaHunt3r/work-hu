import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/donation/data/repository/donation_repository.dart';
import 'package:work_hu/features/donation/providers/donation_provider.dart';
import 'package:work_hu/features/login/data/api/login_api.dart';
import 'package:work_hu/features/login/data/model/register_model.dart';
import 'package:work_hu/features/login/data/repository/login_repository.dart';
import 'package:work_hu/features/login/data/state/login_state.dart';
import 'package:work_hu/features/utils.dart';

final loginApiProvider = Provider<LoginApi>((ref) => LoginApi());

final loginRepoProvider = Provider<LoginRepository>((ref) => LoginRepository(ref.read(loginApiProvider)));

final loginDataProvider = StateNotifierProvider.autoDispose<LoginDataNotifier, LoginState>(
    (ref) => LoginDataNotifier(ref.read(loginRepoProvider), ref.read(donationRepoProvider)));

class LoginDataNotifier extends BaseDataNotifier<LoginState> {
  LoginDataNotifier(this._loginRepository, this._donationRepository) : super(const LoginState()) {
    initGoogleWeb();
    isAlive();
    getDonations();
  }

  final DonationRepository _donationRepository;
  final LoginRepository _loginRepository;
  final UserProvider userProvider = locator<UserProvider>();

  @override
  LoginState copyWithState(BaseState status) {
    return state = state.copyWith(status: status);
  }

  Future<void> login({required String usr, required String pswd, required keepLogedIn}) async {
    executeApiCall<Map<String, dynamic>>(() => _loginRepository.login(usr.trim(), pswd.trim()), onSuccess: (data) async {
      await Utils.saveData("jwt_token", data['token']);
      await Utils.saveData("refresh_token", data['refreshToken']);
      await Utils.saveData("keep_logged_in", keepLogedIn.toString());

      userProvider.setToken(data['token']);
      executeApiCall(() => _loginRepository.getProfile().then((userData) async {
            userProvider.setUser(userData);
          }));
    }, onError: (e) async {
      copyWithState(BaseState(modelState: ModelState.error, message: "login_email_password_wrong".i18n()));
    });
  }

  Future<void> register(
      {required String firstName,
      required String lastName,
      required String email,
      required String pswd,
      required String pswdAgain,
      required bool keepLogedIn}) async {
    if (pswd != pswdAgain) {
      copyWithState(BaseState(modelState: ModelState.error, message: "login_password_not_match".i18n()));
      return;
    }
    executeApiCall<Map<String, dynamic>>(
        () => _loginRepository.register(
            RegisterModel(firstname: firstName.trim(), email: email.trim(), password: pswd.trim(), lastname: lastName.trim())),
        onSuccess: (data) async {
      await Utils.saveData("jwt_token", data['token']);
      await Utils.saveData("refresh_token", data['refreshToken']);
      await Utils.saveData("keep_logged_in", keepLogedIn.toString());

      userProvider.setToken(data['token']);
      executeApiCall(() => _loginRepository.getProfile().then((userData) async {
            userProvider.setUser(userData);
          }));
    });
  }

  Future<void> signInWithGoogle(String idToken) async {
    try {
      executeApiCall<Map<String, dynamic>>(() => _loginRepository.loginWithGoogle(idToken), onSuccess: (data) async {
        await Utils.saveData("jwt_token", data['token']);
        await Utils.saveData("refresh_token", data['refreshToken']);
        userProvider.setToken(data['token']);
        executeApiCall(() => _loginRepository.getUserByUsername(data['username']).then((userData) async {
              userProvider.setUser(userData);
            }));
      });
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
  }

  void initGoogleWeb() async {
    final signIn = GoogleSignIn.instance;

    await signIn
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

  Future<void> sendNewPassword(String username) async {
    executeApiCall<String>(() => _loginRepository.sendNewPassword(username));
  }

  Future<void> getDonations() async {
    try {
      await _donationRepository.getDonations(DateTime.now()).then((data) {
        state = state.copyWith(donations: data);
      });
    } catch (e) {}
  }

  Future<void> isAlive() async {
    try {
      await _loginRepository.isAlive().then((data) {
        state = state.copyWith(status: const BaseState(modelState: ModelState.success, message: ""));
      });
    } catch (e) {
      state = state.copyWith(status: const BaseState(modelState: ModelState.error, message: "server_down"));
    }
  }
}
