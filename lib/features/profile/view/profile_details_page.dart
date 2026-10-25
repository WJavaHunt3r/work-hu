import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/gender.dart';
import 'package:work_hu/app/platform/adaptive.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/profile/data/state/profile_state.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

/// `/profile/details`: the user edits their name, gender and birth date (`PUT /user/{id}`); e-mail, phone, MyShare id
/// and church are shown read only (the church only for users who belong to one).
class ProfileDetailsPage extends BasePage {
  const ProfileDetailsPage({super.key, super.title = "profile_details_title", super.canRefresh = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ProfileDetailsPageState();
}

class ProfileDetailsPageState extends BasePageState<ProfileDetailsPage, ProfileState, ProfileDataNotifier> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _lastname;
  late final TextEditingController _firstname;
  Gender? _gender;
  DateTime? _birthDate;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userDataProvider).user;
    _lastname = TextEditingController(text: user?.lastname == '-' ? '' : user?.lastname);
    _firstname = TextEditingController(text: user?.firstname == '-' ? '' : user?.firstname);
    _gender = user?.gender;
    _birthDate = user?.birthDate;
  }

  @override
  void dispose() {
    _lastname.dispose();
    _firstname.dispose();
    super.dispose();
  }

  String? _required(String? text) => (text == null || text.trim().isEmpty) ? "base_is_required".i18n() : null;

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await pickDate(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final userProvider = ref.read(userDataProvider);
    final user = userProvider.user;
    if (user == null) return;
    setState(() => _saving = true);
    try {
      final updated = await guardApi(
        () => ref
            .read(usersRepoProvider)
            .updateUser(
              user.id,
              user.copyWith(
                lastname: _lastname.text.trim(),
                firstname: _firstname.text.trim(),
                gender: _gender,
                birthDate: _birthDate,
                profileIncomplete: false,
              ),
            ),
      );
      await userProvider.setUser(updated);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("profile_details_saved".i18n())));
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget buildLayout() {
    final theme = Theme.of(context);
    final user = ref.watch(userDataProvider).user;
    if (user == null) return const SizedBox();
    final inset = EdgeInsets.symmetric(horizontal: 18.sp);
    final sectionStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: inset.copyWith(bottom: 8.sp),
            child: Text("profile_details_editable".i18n(), style: sectionStyle),
          ),
          BaseContainer(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseTextFormField(
                  controller: _lastname,
                  labelText: "complete_name_lastname".i18n(),
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.familyName],
                  fldControl: "3",
                  validator: _required,
                ),
                BaseTextFormField(
                  controller: _firstname,
                  labelText: "complete_name_firstname".i18n(),
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.givenName],
                  fldControl: "3",
                  validator: _required,
                ),
                SizedBox(height: 8.sp),
                Text("profile_gender".i18n(), style: theme.textTheme.bodySmall),
                SizedBox(height: 8.sp),
                SizedBox(
                  width: double.infinity,
                  child: AdaptiveSegmented<Gender>(
                    allowEmpty: true,
                    options: {for (final g in Gender.values) g: g.label.i18n()},
                    selected: _gender,
                    // The backend keeps the gender when none is sent, so it can be changed but not removed
                    onChanged: (gender) {
                      if (gender != null) setState(() => _gender = gender);
                    },
                  ),
                ),
                SizedBox(height: 16.sp),
                Material(
                  color: Colors.transparent,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("user_details_date_of_birth".i18n(), style: theme.textTheme.bodySmall),
                    subtitle: Text(
                      _birthDate == null ? "profile_not_set".i18n() : Utils.dateFormating(_birthDate),
                      style: theme.textTheme.bodyLarge,
                    ),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: _pickBirthDate,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.sp),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: _saving ? null : _save, child: Text("base_save".i18n())),
          ),
          SizedBox(height: 32.sp),
          Padding(
            padding: inset.copyWith(bottom: 8.sp),
            child: Text("profile_details_account".i18n(), style: sectionStyle),
          ),
          BaseContainer(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                if (user.churchName != null) ...[
                  _ReadOnlyTile(icon: Icons.church_outlined, label: "profile_church".i18n(), value: user.churchName!),
                  const Divider(height: 1),
                ],
                _ReadOnlyTile(icon: Icons.mail_outline, label: "profile_email".i18n(), value: user.email ?? ""),
                const Divider(height: 1),
                _ReadOnlyTile(
                  icon: Icons.phone_outlined,
                  label: "profile_phone".i18n(),
                  value: user.phoneNumber?.toString() ?? "",
                ),
                if (user.myShareID != null) ...[
                  const Divider(height: 1),
                  _ReadOnlyTile(icon: Icons.badge_outlined, label: "MyShare ID", value: user.myShareID.toString()),
                ],
              ],
            ),
          ),
          Padding(
            padding: inset.copyWith(top: 8.sp),
            child: Text(
              "profile_details_contact_hint".i18n(),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  StateNotifierProvider<ProfileDataNotifier, ProfileState> get provider => profileDataProvider;

  @override
  BaseState get status => state.status;
}

class _ReadOnlyTile extends StatelessWidget {
  const _ReadOnlyTile({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 4.sp),
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(label, style: theme.textTheme.bodySmall),
      subtitle: Text(value.isEmpty ? "–" : value, style: theme.textTheme.bodyLarge),
    );
  }
}
