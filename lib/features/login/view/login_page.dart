import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart' show LocalizationExtension;
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/providers/localeProvider.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/login/data/state/login_state.dart';
import 'package:work_hu/features/login/providers/login_provider.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

class LoginPage extends BasePage {
  LoginPage({
    super.key,
  }) : super(title: 'login_brand_name', leading: Image.asset('icons/dukapp_icon_round.png'));

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends BasePageState<LoginPage, LoginState, LoginDataNotifier> {
  bool _isLogin = true;
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget buildLayout() {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMainCard(theme),
          const SizedBox(height: 24),
          _buildPageFooter(theme),
        ],
      ),
    );
  }

  @override
  List<Widget>? buildActions(context, ref) {
    return [
      SizedBox(
        width: 100,
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
              // onPressed: () => ref.watch(themeProvider.notifier).setTheme(AppThemeMode.dark),
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

    return Card(
      margin: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'login_welcome_title'.i18n(),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'login_welcome_subtitle'.i18n(),
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            _buildToggleButtons(theme),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: _isLogin ? _buildLoginForms() : _buildRegisterForms(),
            ),
            const SizedBox(height: 12),
            _buildRememberMeRow(theme),
            const SizedBox(height: 24),
            _buildLoginButton(theme),
            const SizedBox(height: 20),
            _buildDivider(theme),
            const SizedBox(height: 20),
            _buildGoogleButton(theme),
            const SizedBox(height: 24),
            _buildFooterText(theme),
          ],
        ),
      ),
    );
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordAgainController = TextEditingController();

  _buildLoginForms() {
    return Column(
      children: [
        BaseTextFormField(
          controller: emailController,
          autofillHints: const [AutofillHints.email],
          fldControl: "3",
          labelText: "login_email_label",
          hintText: "login_email_hint",
        ),
        const SizedBox(height: 16),
        BaseTextFormField(
          controller: passwordController,
          autofillHints: const [AutofillHints.password],
          fldControl: "3",
          labelText: "login_password_label",
          hintText: "login_password_hint",
        ),
      ],
    );
  }

  _buildRegisterForms() {
    return Column(
      children: [
        BaseTextFormField(
          controller: nameController,
          labelText: "login_name_label",
          hintText: "login_name_hint",
        ),
        const SizedBox(height: 16),
        BaseTextFormField(
          autofillHints: const [AutofillHints.email],
          controller: emailController,
          labelText: "login_email_label",
          hintText: "login_email_hint",
        ),
        const SizedBox(height: 16),
        BaseTextFormField(
          controller: passwordController,
          labelText: "login_password_label",
          hintText: "login_password_hint",
        ),
        const SizedBox(height: 16),
        BaseTextFormField(
          controller: passwordAgainController,
          labelText: "login_password_again_label",
          hintText: "login_password_again_hint",
        ),
      ],
    );
  }

  Widget _buildToggleButtons(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
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
        color: active ? null : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
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
              onPressed: () {},
              child: Text('login_forgot_password'.i18n(), style: TextStyle(color: theme.colorScheme.onSurface))),
      ],
    );
  }

  Widget _buildLoginButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ref.read(loginDataProvider.notifier).login(usr: emailController.text, pswd: passwordController.text);
          }
        },
        label: const Icon(Icons.arrow_forward, size: 18),
        icon: Text(_isLogin ? 'login_login_button'.i18n() : 'login_register_button'.i18n(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('login_divider_text'.i18n(), style: theme.textTheme.labelSmall)),
        Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
      ],
    );
  }

  Widget _buildGoogleButton(ThemeData theme) {
    // var mode = theme.brightness.name;
    // return OutlinedButton.icon(
    //   iconAlignment: IconAlignment.start,
    //   style: OutlinedButton.styleFrom(
    //     minimumSize: const Size(double.infinity, 54),
    //     padding: const EdgeInsets.symmetric(vertical: 0),
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    //   ),
    //   onPressed: () {
    //     ref.read(loginDataProvider.notifier).signInWithGoogle();
    //   },
    //   icon: Image(
    //     height: 35,
    //     image: AssetImage('logos/$mode/google_sign_in_icon.png'),
    //   ),
    //   label: Text('login_google_login'.i18n(), style: TextStyle(color: theme.colorScheme.onSurface)),
    // );
    return Container(
      height: 50,
      width: double.infinity,
      alignment: Alignment.center,
      child: web.renderButton(
        configuration: web.GSIButtonConfiguration(
          type: web.GSIButtonType.standard,
          theme: web.GSIButtonTheme.outline,
          size: web.GSIButtonSize.large,
          text: web.GSIButtonText.signinWith,
          shape: web.GSIButtonShape.rectangular,
        ),
      ),
    );
  }

  Widget _buildFooterText(ThemeData theme) {
    return Wrap(
      children: [
        Text('login_no_account'.i18n()),
        GestureDetector(
            onTap: () {}, child: Text('login_create_account'.i18n(), style: const TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildPageFooter(ThemeData theme) {
    final style = theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.outline);
    return Column(
      children: [
        Text('login_brand_name'.i18n(), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('login_privacy_policy'.i18n(), style: style),
            const SizedBox(width: 24),
            Text('login_terms_service'.i18n(), style: style),
          ],
        ),
        const SizedBox(height: 32),
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordAgainController.dispose();
    super.dispose();
  }
}
