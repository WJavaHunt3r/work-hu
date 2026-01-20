import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/user_status/providers/user_status_provider.dart';
import 'package:work_hu/features/user_status/view/user_status_layout.dart';

class UserStatusPage extends BasePage {
  const UserStatusPage({super.key, super.title = "admin_myshare_status", super.isListView = true});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return const UserStatusLayout();
  }

  @override
  List<Widget> buildActions(BuildContext context, WidgetRef ref) {
    return ref.watch(userDataProvider)!.isAdmin()
        ? [
            // MaterialButton(
            //   onPressed: ref.watch(userStatusDataProvider).modelState != ModelState.processing
            //       ? () => ref.watch(userStatusDataProvider.notifier).recalculate()
            //       : null,
            //   child: const Icon(Icons.refresh_outlined),
            // ),
            MaterialButton(
              onPressed: ref.watch(userStatusDataProvider).modelState != ModelState.processing
                  ? () => ref.watch(userStatusDataProvider.notifier).setUserStatus()
                  : null,
              child: const Icon(Icons.refresh_outlined),
            )
          ]
        : [];
  }
}
