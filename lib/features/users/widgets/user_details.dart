import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/gender.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_form_field.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/roles/providers/roles_provider.dart';
import 'package:work_hu/features/roles/view/role_edit_page.dart' show permissionLabel;
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

class UserDetails extends ConsumerWidget {
  const UserDetails({super.key, this.enabled = true});

  static final _formKey = GlobalKey<FormState>();
  final bool enabled;

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
                                onChanged: (String text) {},
                              ),
                            ),
                            SizedBox(width: 5.sp),
                            Expanded(
                              child: BaseTextFormField(
                                labelText: "user_details_firstname".i18n(),
                                textAlign: TextAlign.left,
                                initialValue: user.firstname,
                                onChanged: (String text) {},
                              ),
                            ),
                          ],
                        ),
                        BaseTextFormField(
                          labelText: "user_details_date_of_birth".i18n(),
                          initialValue: Utils.dateTimeToDateOnlyString(user.birthDate),
                          onChanged: (String text) {},
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
                        _RolesSection(user: user),
                        TextButton(
                          style: ButtonStyle(
                            // backgroundColor: WidgetStateColor.resolveWith((states) => AppColors.primary),
                            foregroundColor: WidgetStateColor.resolveWith((states) => AppColors.white),
                          ),
                          onPressed: () => ref.watch(userDetailProvider.notifier).resetUserPassword(user.id),
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
