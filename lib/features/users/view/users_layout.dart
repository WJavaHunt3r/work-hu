import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/base_search_bar.dart';
import 'package:work_hu/app/widgets/list_card.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/users/widgets/user_details.dart';

class UsersLayout extends ConsumerWidget {
  const UsersLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var users = ref.watch(usersDataProvider).filtered;
    return Stack(
      children: [
        Column(children: [
          BaseSearchBar(
            onChanged: (text) => ref.watch(usersDataProvider.notifier).filterUsers(text),
          ),
          Expanded(
            child: Stack(children: [
              RefreshIndicator(
                onRefresh: () async => ref.read(usersDataProvider.notifier).getUsers(),
                child: Column(
                  children: [
                    Expanded(
                      child: BaseListView(
                        itemBuilder: (BuildContext context, int index) {
                          return ListCard(
                              isLast: users.length - 1 == index, index: index, child: UserListItem(user: users[index]));
                        },
                        itemCount: users.length,
                        shadowColor: Colors.transparent,
                        cardBackgroundColor: Colors.transparent,
                        children: const [],
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ]),
        Positioned(
          bottom: 20.sp,
          right: 10.sp,
          child: FloatingActionButton(
            child: const Icon(Icons.upload_outlined),
            onPressed: () {
              ref.watch(usersDataProvider.notifier).uploadUserInfo();
            },
          ),
        ),
        Positioned(
          bottom: 20.sp,
          left: 10.sp,
          child: FloatingActionButton(
            heroTag: UniqueKey(),
            child: const Icon(Icons.download_outlined),
            onPressed: () {
              ref.read(usersDataProvider.notifier).downloadUserInfo();
            },
          ),
        ),
        ref.watch(usersDataProvider).modelState == ModelState.processing
            ? const Center(child: CircularProgressIndicator())
            : const SizedBox(),
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
      onTap: () {
        ref.read(usersDataProvider.notifier).setSelectedUser(user);
        showGeneralDialog(
            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: AppColors.primary,
            transitionDuration: const Duration(milliseconds: 200),
            context: context,
            pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
              return const UserDetails();
            }).then((value) => ref.watch(usersDataProvider.notifier).getUsers());
      },
    );
  }
}
