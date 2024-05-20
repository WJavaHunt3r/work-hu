import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';
import 'package:work_hu/features/teams/provider/teams_provider.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

class UserDetails extends ConsumerWidget {
  const UserDetails({super.key});

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserModel user = ref.watch(usersDataProvider).currentUser!;
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
              actions: [
                MaterialButton(
                  onPressed: () =>
                      ref.read(usersDataProvider.notifier).saveUser(user.id, user).then((value) => context.pop()),
                  child: Text("user_details_save".i18n()),
                )
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
                            )),
                            SizedBox(
                              width: 5.sp,
                            ),
                            Expanded(
                                child: BaseTextFormField(
                              labelText: "user_details_firstname".i18n(),
                              textAlign: TextAlign.left,
                              initialValue: user.firstname,
                              onChanged: (String text) {},
                            )),
                          ],
                        ),
                        BaseTextFormField(
                          labelText: "user_details_date_of_birth".i18n(),
                          initialValue: Utils.dateToString(user.birthDate),
                          onChanged: (String text) {},
                        ),
                        BaseTextFormField(
                          labelText: "user_details_email".i18n(),
                          initialValue: user.email ?? "",
                          onChanged: (String text) => text.isNotEmpty
                              ? ref.watch(usersDataProvider.notifier).updateCurrentUser(user.copyWith(email: text))
                              : null,
                        ),
                        BaseTextFormField(
                          labelText: "user_details_phone_number".i18n(),
                          initialValue: user.phoneNumber == null ? "" : user.phoneNumber.toString(),
                          keyBoardType: TextInputType.number,
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
                                initialValue: user.currentMyShareCredit.toString(),
                                keyBoardType: TextInputType.number,
                                onChanged: (String text) => text.isNotEmpty
                                    ? ref
                                        .watch(usersDataProvider.notifier)
                                        .updateCurrentUser(user.copyWith(currentMyShareCredit: num.tryParse(text) ?? 0))
                                    : null,
                              ),
                            ),
                            SizedBox(
                              width: 5.sp,
                            ),
                            Expanded(
                              child: BaseTextFormField(
                                labelText: "user_details_base_myshare_credit".i18n(),
                                initialValue: user.baseMyShareCredit.toString(),
                                keyBoardType: TextInputType.number,
                                onChanged: (String text) => text.isNotEmpty
                                    ? ref
                                        .watch(usersDataProvider.notifier)
                                        .updateCurrentUser(user.copyWith(baseMyShareCredit: num.tryParse(text) ?? 0))
                                    : null,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4.sp, bottom: 4.sp),
                          child: DropdownButtonFormField(
                              decoration: InputDecoration(labelText: "user_details_team".i18n()),
                              value: ref.watch(teamsDataProvider).teams.isEmpty ? null : user.team,
                              items: createTeamsDropDownList(ref),
                              onChanged: (value) =>
                                  ref.watch(usersDataProvider.notifier).updateCurrentUser(user.copyWith(team: value))),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4.sp, bottom: 4.sp),
                          child: DropdownButtonFormField(
                              decoration:
                                  InputDecoration(fillColor: Colors.white, labelText: "user_details_role".i18n()),
                              value: user.role,
                              items: Role.values
                                  .map((e) => DropdownMenuItem<Role>(
                                        value: e,
                                        child: Text(e.toString()),
                                      ))
                                  .toList(),
                              onChanged: (value) => value != null
                                  ? ref.watch(usersDataProvider.notifier).updateCurrentUser(user.copyWith(role: value))
                                  : null),
                        ),
                        TextButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateColor.resolveWith((states) => AppColors.primary),
                              foregroundColor: WidgetStateColor.resolveWith((states) => AppColors.white),
                            ),
                            onPressed: () => ref.watch(usersDataProvider.notifier).resetUserPassword(user.id),
                            child: Text(
                              "user_details_reset_password".i18n(),
                              style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                            ))
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
              child: Text(e.color.toString()),
            ))
        .toList();
    list.add(const DropdownMenuItem(
      value: null,
      child: Text(""),
    ));
    return list;
  }
}
