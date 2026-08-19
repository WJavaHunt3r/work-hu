import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in_web/web_only.dart' as web;
import 'package:intl/intl.dart';
import 'package:localization/localization.dart' show LocalizationExtension;
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/localeProvider.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/features/login/data/state/login_state.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';
import 'package:work_hu/features/utils.dart';

class LoginPage extends BasePage {
  LoginPage({
    super.key,
  }) : super(
            title: 'login_brand_name',
            leading: Padding(
              padding: EdgeInsets.all(4.sp),
              child: Image.asset('assets/icons/dukapp_icon_round.png'),
            ),
            canRefresh: false);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends BasePageState<LoginPage, LoginState, LoginDataNotifier> {
  bool _isLogin = true;
  bool _rememberMe = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget buildLayout() {
    final theme = Theme.of(context);
    if (state.status.modelState.isError && state.status.message.contains("server_down")) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_outlined, size: 32.sp, color: theme.colorScheme.error),
          Text('server_down'.i18n(), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 16.sp),
          IconButton(onPressed: () => ref.read(provider.notifier).isAlive(), icon: Icon(Icons.refresh, size: 32.sp)),
          SizedBox(height: 24.sp),
          _buildPageFooter(theme),
        ],
      );
    } else {
      return Column(
        children: [
          _buildMainCard(theme),
          SizedBox(height: 24.sp),
          if (state.donations.isNotEmpty) _buildDonations(theme),
          SizedBox(height: 24.sp),
          _buildPageFooter(theme),
        ],
      );
    }
  }

  _buildDonations(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('home_donations'.i18n(), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        Column(
            children: state.donations.map((e) {
          return BaseContainer(
              width: double.infinity,
              height: 150.sp,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      ref.watch(localeProvider).value == const Locale("hu", "HU")
                          ? e.description.toString()
                          : e.descriptionNO.toString(),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                      "${DateFormat('MMM dd, yyyy • HH:mm').format(e.startDateTime!)} - ${DateFormat('MMM dd, yyyy • HH:mm').format(e.endDateTime!)}"),
                  FilledButton(onPressed: () => context.push("/donate/${e.id}"), child: Text("home_donate".i18n()))
                ],
              ));
        }).toList()),
        SizedBox(height: 16.sp),
      ],
    );
  }

  @override
  List<Widget>? buildActions(context, ref) {
    return [
      SizedBox(
        width: 120.sp,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            final localeAsync = ref.watch(localeProvider);

            final selectedLocale = localeAsync.value ?? defaultLocale;
            final currentLocale = supportedLocales[index];

            final isSelected = selectedLocale.languageCode == currentLocale.languageCode;

            return TextButton(
              onPressed: () => ref.read(localeProvider.notifier).setLocale(currentLocale),
              child: Text(
                currentLocale.languageCode.toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Center(child: Text("|"));
          },
          itemCount: supportedLocales.length,
        ),
      )
    ];
  }

  Widget _buildMainCard(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return BaseContainer(
      child: Column(
        children: [
          Text(
            'login_welcome_title'.i18n(),
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.sp),
          Text(
            'login_welcome_subtitle'.i18n(),
            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          SizedBox(height: 24.sp),
          _buildToggleButtons(theme),
          SizedBox(height: 24.sp),
          Form(
            key: _formKey,
            child: _isLogin ? _buildLoginForms() : _buildRegisterForms(),
          ),
          SizedBox(height: 12.sp),
          _buildRememberMeRow(theme),
          SizedBox(height: 24.sp),
          _buildLoginButton(theme),
          SizedBox(height: 20.sp),
          _buildDivider(theme),
          SizedBox(height: 20.sp),
          _buildGoogleButton(theme),
          SizedBox(height: 24.sp),
          _isLogin ? _buildFooterText(theme) : const SizedBox(),
        ],
      ),
    );
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordAgainController = TextEditingController();

  _buildLoginForms() {
    return AutofillGroup(
        key: const ValueKey('login_autofill_group'),
        child: Column(
      children: [
        BaseTextFormField(
          controller: emailController,
          keyBoardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email, AutofillHints.username],
          textInputAction: TextInputAction.next,
          fldControl: "3",
          labelText: "login_email_label",
          hintText: "login_email_hint",
        ),
        SizedBox(height: 16.sp),
        BaseTextFormField(
          controller: passwordController,
          textInputAction: TextInputAction.send,
          autofillHints: const [AutofillHints.password],
          isPasswordField: true,
          fldControl: "3",
          labelText: "login_password_label",
          hintText: "login_password_hint",
          onFieldSubmitted: (t) {
            login();
          },
        ),
      ],
    ));
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      TextInput.finishAutofillContext(shouldSave: true);
      _isLogin
          ? ref
              .read(loginDataProvider.notifier)
              .login(usr: emailController.text, pswd: passwordController.text, keepLogedIn: _rememberMe)
          : ref.read(loginDataProvider.notifier).register(
              keepLogedIn: _rememberMe,
              lastName: lastNameController.text,
              email: emailController.text,
              firstName: firstNameController.text,
              pswd: passwordController.text,
              pswdAgain: passwordAgainController.text);
    }
  }

  _buildRegisterForms() {
    return AutofillGroup(
        key: const ValueKey('login_register_group'),
        child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: BaseTextFormField(
                fldControl: "3",
                autofillHints: const [AutofillHints.name, AutofillHints.givenName],
                controller: firstNameController,
                labelText: "login_firstname_label",
                hintText: "login_firstname_hint",
              ),
            ),
            SizedBox(width: 16.sp),
            Expanded(
              child: BaseTextFormField(
                fldControl: "3",
                autofillHints: const [AutofillHints.name, AutofillHints.familyName],
                controller: lastNameController,
                labelText: "login_lastname_label",
                hintText: "login_lastname_hint",
              ),
            ),
          ],
        ),
        SizedBox(height: 16.sp),
        BaseTextFormField(
          fldControl: "3",
          keyBoardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          controller: emailController,
          labelText: "login_email_label",
          hintText: "login_email_hint",
          validator: (text) {
            if (text == null || text.isEmpty) {
              return "base_is_required".i18n();
            }
            if (!text.contains("@")) {
              return "login_email_error".i18n();
            }
            return null;
          },
        ),
        SizedBox(height: 16.sp),
        BaseTextFormField(
          fldControl: "3",
          controller: passwordController,
          isPasswordField: true,
          labelText: "login_password_label",
          hintText: "login_password_hint",
        ),
        SizedBox(height: 16.sp),
        BaseTextFormField(
          isPasswordField: true,
          controller: passwordAgainController,
          labelText: "login_password_again_label",
          hintText: "login_password_again_hint",
        ),
      ],
    ));
  }

  Widget _buildToggleButtons(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(2.sp),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Row(
        children: [
          Expanded(child: _toggleItem(theme, 'login_toggle_login'.i18n(), _isLogin, () => setState(() => _isLogin = true))),
          Expanded(child: _toggleItem(theme, 'login_toggle_register'.i18n(), !_isLogin, () => setState(() => _isLogin = false))),
        ],
      ),
    );
  }

  Widget _toggleItem(ThemeData theme, String text, bool active, VoidCallback onTap) {
    final colorScheme = theme.colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)),
        color: active ? null : Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.sp),
          child: Center(
            child: Text(
              text,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMeRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(value: _rememberMe, onChanged: (v) => setState(() => _rememberMe = v!)),
            Text('login_remember_me'.i18n(), style: theme.textTheme.bodyMedium),
          ],
        ),
        if (_isLogin)
          TextButton(
              onPressed: () {
                if (emailController.text.isEmpty) {
                  Utils.showErrorDialog(context, content: 'login_reset_empty_username'.i18n());
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => ConfirmAlertDialog(
                          onConfirm: () => ref
                              .read(loginDataProvider.notifier)
                              .sendNewPassword(emailController.text)
                              .then((r) => context.pop()),
                          title: 'login_reset_password_confirm_title'.i18n(),
                          content: Text("login_reset_password_question".i18n())));
                }
              },
              child: Text('login_forgot_password'.i18n(), style: TextStyle(color: theme.colorScheme.onSurface))),
      ],
    );
  }

  Widget _buildLoginButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () {
          login();
        },
        label: Icon(Icons.arrow_forward, size: 18.sp),
        icon: Text(_isLogin ? 'login_login_button'.i18n() : 'login_register_button'.i18n(),
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Text('login_divider_text'.i18n(), style: theme.textTheme.labelSmall)),
        Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
      ],
    );
  }

  Widget _buildGoogleButton(ThemeData theme) {
    var lngCode = ref.watch(localeProvider).value?.languageCode;
    return Container(
      height: 50.sp,
      width: double.infinity,
      alignment: Alignment.center,
      child: web.renderButton(
          configuration: web.GSIButtonConfiguration(
        type: web.GSIButtonType.standard,
        theme: web.GSIButtonTheme.outline,
        size: web.GSIButtonSize.large,
        text: _isLogin ? web.GSIButtonText.signinWith : web.GSIButtonText.signupWith,
        shape: web.GSIButtonShape.rectangular,
        locale: lngCode,
      )),
    );
  }

  Widget _buildFooterText(ThemeData theme) {
    return Wrap(
      children: [
        Text('login_no_account'.i18n()),
        GestureDetector(
            onTap: () {
              setState(() {
                _isLogin = false;
              });
            },
            child: Text('login_create_account'.i18n(), style: const TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildPageFooter(ThemeData theme) {
    final style = theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.outline);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.sp),
          child: Text(
            'login_app_description'.i18n(), // "A DukApp egy biztonságos adománygyűjtő platform..."
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        SizedBox(height: 24.sp),
        Text('login_brand_name'.i18n(), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 24.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Text('login_privacy_policy'.i18n(), style: style),
              onPressed: () => context.go("/privacy"),
            ),
            SizedBox(width: 24.sp),
            TextButton(
              child: Text('login_terms_service'.i18n(), style: style),
              onPressed: () => context.go("/tos"),
            ),
          ],
        ),
        SizedBox(height: 32.sp),
        Text('login_copyright'.i18n(),
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline), textAlign: TextAlign.center),
      ],
    );
  }

  @override
  AutoDisposeStateNotifierProvider<LoginDataNotifier, LoginState> get provider => loginDataProvider;

  @override
  BaseState get status => state.status;

  @override
  void dispose() {
    firstNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordAgainController.dispose();
    super.dispose();
  }
}
