import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/extensions/dark_mode.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/theme_provider.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';
import 'package:work_hu/features/teams/provider/teams_provider.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

class UserDetails extends ConsumerWidget {
  const UserDetails({super.key, required this.user, this.enabled = true});

  static final _formKey = GlobalKey<FormState>();
  final UserModel user;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentUser = ref.watch(userDataProvider);
    bool isEnabled = currentUser != null && currentUser.isAdmin() && enabled;
    return Dialog.fullscreen(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
              title: Text(
                user.getFullName(),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              actions: isEnabled
                  ? [
                      MaterialButton(
                        onPressed: () => ref.read(usersDataProvider.notifier).saveUser().then((value) => context.pop()),
                        child: Text("user_details_save".i18n()),
                      )
                    ]
                  : null,
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
                              enabled: isEnabled,
                              onChanged: (String text) {},
                            )),
                            SizedBox(
                              width: 5.sp,
                            ),
                            Expanded(
                                child: BaseTextFormField(
                              labelText: "user_details_firstname".i18n(),
                              textAlign: TextAlign.left,
                              initialValue: user.firstname,
                              enabled: isEnabled,
                              onChanged: (String text) {},
                            )),
                          ],
                        ),
                        BaseTextFormField(
                          labelText: "user_details_date_of_birth".i18n(),
                          initialValue: Utils.dateToString(user.birthDate),
                          enabled: isEnabled,
                          onChanged: (String text) {},
                        ),
                        BaseTextFormField(
                          labelText: "user_details_email".i18n(),
                          initialValue: user.email ?? "",
                          enabled: isEnabled,
                          onChanged: (String text) => text.isNotEmpty
                              ? ref.watch(usersDataProvider.notifier).updateCurrentUser(user.copyWith(email: text))
                              : null,
                        ),
                        BaseTextFormField(
                          labelText: "user_details_phone_number".i18n(),
                          initialValue: user.phoneNumber == null ? "" : user.phoneNumber.toString(),
                          keyBoardType: TextInputType.number,
                          enabled: isEnabled,
                          onChanged: (String text) => text.isNotEmpty
                              ? ref
                                  .watch(usersDataProvider.notifier)
                                  .updateCurrentUser(user.copyWith(phoneNumber: num.tryParse(text) ?? 0))
                              : null,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: BaseTextFormField(
                                  enabled: false,
                                  labelText: "user_details_myshare_credit".i18n(),
                                  initialValue: Utils.creditFormatting(user.currentMyShareCredit),
                                  keyBoardType: TextInputType.number,
                                  onChanged: (String text) => {}),
                            ),
                            SizedBox(
                              width: 5.sp,
                            ),
                            if (currentUser?.isAdmin() ?? false)
                              Expanded(
                                child: BaseTextFormField(
                                  labelText: "user_details_base_myshare_credit".i18n(),
                                  initialValue: user.baseMyShareCredit.toString(),
                                  keyBoardType: TextInputType.number,
                                  enabled: isEnabled,
                                  onChanged: (String text) => text.isNotEmpty
                                      ? ref
                                          .watch(usersDataProvider.notifier)
                                          .updateCurrentUser(user.copyWith(baseMyShareCredit: num.tryParse(text) ?? 0))
                                      : null,
                                ),
                              )
                          ],
                        ),
                        isEnabled
                            ? Padding(
                                padding: EdgeInsets.only(top: 4.sp, bottom: 4.sp),
                                child: DropdownButtonFormField(
                                    dropdownColor:
                                    ref.watch(themeProvider) == ThemeMode.dark ? AppColors.primary200 : AppColors.backgroundColor,
                                    decoration: InputDecoration(labelText: "user_details_team".i18n()),
                                    value: ref.watch(teamsDataProvider).teams.isEmpty ? null : user.paceTeam,
                                    items: createTeamsDropDownList(ref),
                                    onChanged: (value) => ref
                                        .watch(usersDataProvider.notifier)
                                        .updateCurrentUser(user.copyWith(paceTeam: value))),
                              )
                            : BaseTextFormField(
                                labelText: "user_details_team".i18n(),
                                initialValue: user.paceTeam?.teamName ?? "",
                                keyBoardType: TextInputType.number,
                                enabled: false,
                                onChanged: (String text) => null,
                              ),
                        isEnabled
                            ? Padding(
                                padding: EdgeInsets.only(top: 4.sp, bottom: 4.sp),
                                child: DropdownButtonFormField(
                                    dropdownColor:
                                    ref.watch(themeProvider) == ThemeMode.dark ? AppColors.primary200 : AppColors.backgroundColor,
                                    decoration: InputDecoration(labelText: "user_details_role".i18n(), isDense: true),
                                    value: user.role,
                                    items: Role.values
                                        .map((e) => DropdownMenuItem<Role>(
                                              value: e,
                                              child: Text(e.toString()),
                                            ))
                                        .toList(),
                                    onChanged: (value) => value != null
                                        ? ref
                                            .watch(usersDataProvider.notifier)
                                            .updateCurrentUser(user.copyWith(role: value))
                                        : null),
                              )
                            : SizedBox(),
                        isEnabled
                            ? TextButton(
                                style: ButtonStyle(
                                  // backgroundColor: WidgetStateColor.resolveWith((states) => AppColors.primary),
                                  foregroundColor: WidgetStateColor.resolveWith((states) => AppColors.white),
                                ),
                                onPressed: () => ref.watch(usersDataProvider.notifier).resetUserPassword(user.id),
                                child: Text(
                                  "user_details_reset_password".i18n(),
                                  style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                                ))
                            : SizedBox()
                      ],
                    ),
                  )),
            )));
  }

  createTeamsDropDownList(WidgetRef ref) {
    var list = ref
        .watch(teamsDataProvider)
        .teams
        .map((e) => DropdownMenuItem<TeamModel>(
              value: e,
              child: Text(e.teamName.toString()),
            ))
        .toList();
    list.add(const DropdownMenuItem(
      value: null,
      child: Text(""),
    ));
    return list;
  }
}
