import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/users/widgets/user_details.dart';

class UsersLayout extends ConsumerWidget {
  const UsersLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        SingleChildScrollView(
            child: Card(
          margin: EdgeInsets.only(bottom: 8.sp),
          child: ListView.builder(
            itemCount: ref.watch(usersDataProvider).users.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var current = ref.watch(usersDataProvider).users[index];
              return UserListItem(user: current);
            },
          ),
        )),
        ref.watch(usersDataProvider).modelState == ModelState.processing
            ? const Center(child: CircularProgressIndicator())
            : const SizedBox()
      ],
    );
  }
}

class UserListItem extends ConsumerWidget {
  const UserListItem({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
        title: Text(user.getFullName()),
        trailing: IconButton(
            onPressed: () {
              ref.read(usersDataProvider.notifier).setSelectedUser(user);
              showGeneralDialog(
                  barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                  barrierColor: AppColors.primary,
                  transitionDuration: const Duration(milliseconds: 200),
                  context: context,
                  pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                    return UserDetails();
                  }).then((value) => ref.watch(usersDataProvider.notifier).getUsers());
            },
            icon: const Icon(Icons.open_in_new)));
  }
}
