import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/profile/providers/profile_providers.dart';
import 'package:work_hu/features/profile/view/profile_layout.dart';

import '../../../app/framework/base_components/main_screen.dart';

class ProfilePage extends MainScreen {
  const ProfilePage(
      {super.key,
      super.title = "",
      super.isListView = true,
      super.selectedIndex = 1,
      super.extendBodyBehindAppBar = true});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return ref.watch(profileDataProvider).modelState == ModelState.processing
        ? const Center(child: CircularProgressIndicator())
        : const ProfileLayout();
  }
}
