import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/title_provider.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/profile/view/profile_layout.dart';

class ProfilePage extends BasePage {
  const ProfilePage({super.key, super.title = "Profile", super.isListView = true});

  @override
  List<Widget> buildActions(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userDataProvider);
    return user != null && user.role != Role.USER || user != null && user.isMentor()
        ? [
            IconButton(
                onPressed: () {
                  ref.watch(titleDataProvider.notifier).setTitle("Mentees");
                  context.push("/admin").then((value) => ref.watch(profileDataProvider.notifier).getUserInfo());
                },
                icon: const Icon(Icons.admin_panel_settings_outlined))
          ]
        : [];
  }

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return ref.watch(profileDataProvider).modelState == ModelState.processing
        ? const Center(child: CircularProgressIndicator())
        : const ProfileLayout();
  }
}
