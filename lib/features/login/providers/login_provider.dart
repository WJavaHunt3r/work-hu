import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
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
    initGoogle();
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
        await Utils.saveData("keep_logged_in", "true");
        userProvider.setToken(data['token']);
        executeApiCall(() => _loginRepository.getUserByUsername(data['username']).then((userData) async {
              userProvider.setUser(userData);
            }));
      });
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
  }

  static const _googleWebClientId = "470140408680-vvsu3rjroghr7suq603r4eek5lec5bds.apps.googleusercontent.com";
  static Future<void>? _googleInit;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _googleSub;

  Future<void> initGoogle() async {
    final signIn = GoogleSignIn.instance;

    // initialize() may only be called once per app run.
    // Web uses the web client id as clientId; on Android/iOS the web client id is the
    // serverClientId, so the ID token's audience matches what the backend verifies.
    _googleInit ??= signIn.initialize(
      clientId: kIsWeb ? _googleWebClientId : null,
      serverClientId: kIsWeb ? null : _googleWebClientId,
    );
    await _googleInit;

    _googleSub = signIn.authenticationEvents.listen((event) async {
      if (event is GoogleSignInAuthenticationEventSignIn) {
        final String? idToken = event.user.authentication.idToken;
        if (idToken != null) {
          await signInWithGoogle(idToken);
        }
      }
    }, onError: (Object e) => print("Google Sign-In Error: $e"));
  }

  /// Android / iOS: opens the native account picker. The result is delivered
  /// through [GoogleSignIn.authenticationEvents] (see [initGoogle]).
  Future<void> signInWithGoogleNative() async {
    try {
      await _googleInit;
      if (!GoogleSignIn.instance.supportsAuthenticate()) return;
      await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code != GoogleSignInExceptionCode.canceled) {
        print("Google Sign-In Error: $e");
      }
    }
  }

  @override
  void dispose() {
    _googleSub?.cancel();
    super.dispose();
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
