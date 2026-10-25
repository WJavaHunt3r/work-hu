import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/gender.dart';
import 'package:work_hu/app/models/permission.dart';
import 'package:work_hu/app/platform/adaptive.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_form_field.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/churches/church_model.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/roles/providers/roles_provider.dart';
import 'package:work_hu/features/roles/view/role_edit_page.dart' show permissionLabel;
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

class UserDetails extends ConsumerWidget {
  const UserDetails({super.key, this.enabled = true});

  static final _formKey = GlobalKey<FormState>();
  final bool enabled;

  /// Deleting needs USER_MANAGE, and you can't delete yourself.
  bool _canDelete(WidgetRef ref, UserModel user) {
    final me = ref.watch(userDataProvider).user;
    return me != null && me.hasPermission(Permission.USER_MANAGE) && me.id != user.id;
  }

  /// Asks first; the backend refuses users with history (transactions, activities, ...) and says why.
  Future<void> _delete(BuildContext context, WidgetRef ref, UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AdaptiveAlertDialog(
        title: Text("user_delete".i18n()),
        content: Text("user_delete_question".i18n([user.getFullName()])),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text("base_cancel".i18n())),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text("user_delete".i18n())),
        ],
      ),
    );
    if (confirmed != true) return;
    final deleted = await ref.read(userDetailProvider.notifier).deleteUser();
    if (deleted && context.mounted) context.pop(true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userDetailProvider).selectedUser;
    return Dialog.fullscreen(
      child: user == null
          ? Scaffold(
              body: Padding(
                padding: EdgeInsets.all(8.sp),
                child: Center(child: Text("user_no_user".i18n())),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
                title: Text(user.getFullName(), style: const TextStyle(fontWeight: FontWeight.w800)),
                actions: [
                  if (_canDelete(ref, user))
                    IconButton(
                      tooltip: "user_delete".i18n(),
                      icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                      onPressed: () => _delete(context, ref, user),
                    ),
                  MaterialButton(
                    onPressed: () async {
                      final saved = await ref.read(userDetailProvider.notifier).saveUser();
                      if (saved && context.mounted) context.pop(true);
                    },
                    child: Text("user_details_save".i18n()),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: BaseTextFormField(
                                labelText: "user_details_lastname".i18n(),
                                textAlign: TextAlign.left,
                                initialValue: user.lastname,
                                onChanged: (String text) => text.trim().isNotEmpty
                                    ? ref
                                          .read(userDetailProvider.notifier)
                                          .updateCurrentUser(user.copyWith(lastname: text.trim()))
                                    : null,
                              ),
                            ),
                            SizedBox(width: 5.sp),
                            Expanded(
                              child: BaseTextFormField(
                                labelText: "user_details_firstname".i18n(),
                                textAlign: TextAlign.left,
                                initialValue: user.firstname,
                                onChanged: (String text) => text.trim().isNotEmpty
                                    ? ref
                                          .read(userDetailProvider.notifier)
                                          .updateCurrentUser(user.copyWith(firstname: text.trim()))
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        BaseLabeledField(
                          labelText: "user_details_date_of_birth".i18n(),
                          child: InkWell(
                            onTap: () async {
                              final now = DateTime.now();
                              final picked = await pickDate(
                                context: context,
                                initialDate: user.birthDate ?? DateTime(now.year - 20),
                                firstDate: DateTime(1900),
                                lastDate: now,
                              );
                              if (picked != null) {
                                ref
                                    .read(userDetailProvider.notifier)
                                    .updateCurrentUser(user.copyWith(birthDate: picked));
                              }
                            },
                            child: InputDecorator(
                              decoration: baseInputDecoration(
                                Theme.of(context),
                                suffixIcon: const Icon(Icons.calendar_today_outlined),
                              ),
                              child: Text(
                                user.birthDate == null ? " " : Utils.dateTimeToDateOnlyString(user.birthDate),
                              ),
                            ),
                          ),
                        ),
                        BaseTextFormField(
                          labelText: "user_details_email".i18n(),
                          initialValue: user.email ?? "",
                          onChanged: (String text) => text.isNotEmpty
                              ? ref.watch(userDetailProvider.notifier).updateCurrentUser(user.copyWith(email: text))
                              : null,
                        ),
                        BaseTextFormField(
                          labelText: "user_details_phone_number".i18n(),
                          initialValue: user.phoneNumber == null ? "" : user.phoneNumber.toString(),
                          keyBoardType: TextInputType.number,
                          onChanged: (String text) => text.isNotEmpty
                              ? ref
                                    .watch(userDetailProvider.notifier)
                                    .updateCurrentUser(user.copyWith(phoneNumber: num.tryParse(text) ?? 0))
                              : null,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: BaseTextFormField(
                                enabled: false,
                                labelText: "user_details_myshare_credit".i18n(),
                                initialValue: Utils.creditFormatting(0),
                                keyBoardType: TextInputType.number,
                                onChanged: (String text) => {},
                              ),
                            ),
                            SizedBox(width: 5.sp),
                            Expanded(
                              child: BaseTextFormField(
                                labelText: "user_details_base_myshare_credit".i18n(),
                                initialValue: user.baseMyShareCredit.toString(),
                                keyBoardType: TextInputType.number,
                                onChanged: (String text) => text.isNotEmpty
                                    ? ref
                                          .watch(userDetailProvider.notifier)
                                          .updateCurrentUser(user.copyWith(baseMyShareCredit: num.tryParse(text) ?? 0))
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        // isEnabled
                        //     ? WorkDropDownSearchFormField<TeamModel>(
                        //         controller: TextEditingController(),
                        //         onSuggestionSelected: (value) =>
                        //             ref.watch(userDetailProvider.notifier).updateCurrentUser(user.copyWith(paceTeam: value)),
                        //         itemBuilder: (context, e) => Text(e.teamName.toString()),
                        //         suggestionsCallback: (value) => ref.watch(teamsDataProvider).teams,
                        //         labelText: '',
                        //       )
                        //     : BaseTextFormField(
                        //         labelText: "user_details_team".i18n(),
                        //         initialValue: user.paceTeam?.teamName ?? "",
                        //         keyBoardType: TextInputType.number,
                        //         enabled: false,
                        //         onChanged: (String text) => null,
                        //       ),
                        BaseDropdownFormField<Gender?>(
                          labelText: "user_details_gender",
                          initialValue: user.gender,
                          items: [
                            const DropdownMenuItem<Gender?>(value: null, child: Text("")),
                            ...Gender.values.map(
                              (e) => DropdownMenuItem<Gender?>(value: e, child: Text(e.label.i18n())),
                            ),
                          ],
                          onChanged: (value) =>
                              ref.read(userDetailProvider.notifier).updateCurrentUser(user.copyWith(gender: value)),
                        ),
                        _ChurchField(user: user),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
                          title: Text("user_details_member".i18n()),
                          subtitle: Text("user_details_member_hint".i18n()),
                          value: user.member,
                          onChanged: (value) =>
                              ref.read(userDetailProvider.notifier).updateCurrentUser(user.copyWith(member: value)),
                        ),
                        _RolesSection(user: user),
                        TextButton(
                          style: ButtonStyle(
                            // backgroundColor: WidgetStateColor.resolveWith((states) => AppColors.primary),
                            foregroundColor: WidgetStateColor.resolveWith((states) => AppColors.white),
                          ),
                          onPressed: () => _sendResetLink(context, ref, user),
                          child: Text(
                            "user_details_reset_password".i18n(),
                            style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

/// The user's church; only user managers can change it (it decides which screens the user gets).
class _ChurchField extends ConsumerWidget {
  const _ChurchField({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(userDetailProvider.notifier);
    final churches = ref.watch(churchesProvider).value ?? const <ChurchModel>[];
    // A church that is not in the list (yet) must still be selectable, or the dropdown would fail
    final selected = churches.any((c) => c.id == user.churchId) ? user.churchId : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseDropdownFormField<num?>(
          // New key when the list arrives, so the dropdown shows the loaded value
          key: ValueKey("church-${churches.length}-${user.id}"),
          labelText: "user_details_church".i18n(),
          initialValue: selected,
          items: [
            DropdownMenuItem<num?>(value: null, child: Text("user_details_church_none".i18n())),
            for (final c in churches) DropdownMenuItem<num?>(value: c.id, child: Text(c.churchName)),
          ],
          onChanged: notifier.canManageUsers
              ? (value) => notifier.updateCurrentUser(user.copyWith(churchId: value))
              : null,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.sp),
          child: Text("user_details_church_hint".i18n(), style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}

/// The roles of the user as one checkbox per role; changing them needs the ROLE_MANAGE permission.
/// The user's effective permissions are the union of the permissions of all checked roles.
class _RolesSection extends ConsumerWidget {
  const _RolesSection({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(userDetailProvider.notifier);
    final roles = ref.watch(allRolesProvider);
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("user_details_roles".i18n(), style: Theme.of(context).textTheme.titleMedium),
          roles.when(
            loading: () => const Center(child: CircularProgressIndicator.adaptive()),
            error: (_, _) => Text(user.roleNames.join(", ")),
            data: (all) => Column(
              children: [
                for (final role in all)
                  CheckboxListTile.adaptive(
                    activeColor: Theme.of(context).colorScheme.primary,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: user.roleNames.contains(role.name),
                    title: Text(role.name),
                    subtitle: role.description == null ? null : Text(role.description!),
                    onChanged: notifier.canManageRoles
                        ? (checked) => notifier.toggleRole(role.name, checked == true)
                        : null,
                  ),
              ],
            ),
          ),
          if (user.permissions.isNotEmpty) ...[
            SizedBox(height: 8.sp),
            Text("user_details_permissions".i18n(), style: Theme.of(context).textTheme.titleSmall),
            Wrap(
              spacing: 4.sp,
              children: [
                for (final p in user.permissions)
                  Chip(label: Text(permissionLabel(p)), visualDensity: VisualDensity.compact),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Admin "reset password": e-mails the user a one-time link to set a new one, after asking.
Future<void> _sendResetLink(BuildContext context, WidgetRef ref, UserModel user) async {
  final email = user.email ?? "";
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AdaptiveAlertDialog(
      title: Text("user_details_reset_password".i18n()),
      content: Text(
        email.isEmpty ? "user_details_reset_no_email".i18n() : "user_details_reset_question".i18n([email]),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        if (email.isNotEmpty)
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text("security_send".i18n())),
      ],
    ),
  );
  if (confirmed != true) return;
  final sent = await ref.read(userDetailProvider.notifier).resetUserPassword(user.id);
  if (sent && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("user_details_reset_sent".i18n([email]))));
  }
}
