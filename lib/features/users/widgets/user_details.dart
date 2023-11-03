import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/utils.dart';

class UserDetails extends ConsumerWidget {
  UserDetails({super.key});

  final _formKey = GlobalKey<FormState>();

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
          "${user.lastname} ${user.firstname}",
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          MaterialButton(
            onPressed: () => ref.read(usersDataProvider.notifier).saveUser(user.id, user),
            child: const Text("Save"),
          )
        ],
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: BaseTextFormField(
                      labelText: "Lastname",
                      initialValue: user.lastname,
                    )),
                    Expanded(
                        child: BaseTextFormField(
                      labelText: "Firstname",
                      initialValue: user.firstname,
                    )),
                  ],
                ),
                BaseTextFormField(
                  labelText: "Date of birth",
                  initialValue: Utils.dateToString(user.birthDate),
                ),
                Row(
                  children: [
                    Expanded(
                      child: BaseTextFormField(
                        labelText: "MyShare goal",
                        initialValue: user.goal.toString(),
                      ),
                    ),
                    Expanded(
                      child: BaseTextFormField(
                        enabled: false,
                        labelText: "Current MyShare credit",
                        initialValue: user.currentMyShareCredit.toString(),
                      ),
                    ),
                  ],
                ),
                user.team != null
                    ? BaseTextFormField(
                        labelText: "Team",
                        initialValue: user.team!.color,
                      )
                    : const SizedBox(),
                Padding(
                  padding: EdgeInsets.all(4.sp),
                  child: DropdownButtonFormField(
                      decoration: const InputDecoration(fillColor: Colors.transparent, labelText: "Role"),
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
                      backgroundColor: MaterialStateColor.resolveWith((states) => AppColors.primary),
                      foregroundColor: MaterialStateColor.resolveWith((states) => AppColors.white),
                    ),
                    onPressed: () => ref.watch(usersDataProvider.notifier).resetUserPassword(user.id),
                    child: const Text(
                      "Reset password",
                      style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          )),
    ));
  }
}
