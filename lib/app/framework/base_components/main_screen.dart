import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/notch_app_bar.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/dukapp.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

abstract class MainScreen extends BasePage {
  MainScreen(
      {required this.selectedIndex,
      super.key,
      required super.title,
      super.isListView,
      super.appBarTextStyle,
      super.extendBodyBehindAppBar,
      super.automaticallyImplyLeading = false,
      super.centerTitle,
      super.leading});

  final int selectedIndex;

  @override
  buildBottomNavigationBar(BuildContext context, WidgetRef ref) {
    UserModel? currentUser = ref.watch(userDataProvider);
    return currentUser != null && currentUser.isUser()
        ? NotchAppBar(selectedIndex)
        : Container(
            decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24.sp), topRight: Radius.circular(24.sp))),
            child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                selectedIconTheme: const IconThemeData(color: AppColors.primary),
                elevation: 0,
                items: currentUser == null
                    ? noUserScreens()
                    : currentUser.isUser()
                        ? userScreens()
                        : adminScreens(),
                currentIndex: selectedIndex,
                selectedFontSize: 16,
                onTap: (int index) => _onItemTapped(index, ref, currentUser)),
          );
  }

  void _onItemTapped(int index, WidgetRef ref, UserModel? currentUser) {
    if (index != selectedIndex) {
      if (index == 0) {
        ref.watch(routerProvider).go("/home");
      }
      if (index == 1) {
        if (currentUser == null) {
          ref.watch(routerProvider).go("/login");
        } else {
          ref.watch(routerProvider).go("/profile");
        }
      }
      if (index == 2) {
        ref.watch(routerProvider).go("/admin");
      }
    }
  }

  List<BottomNavigationBarItem> noUserScreens() => <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.run_circle_rounded),
            icon: const Icon(Icons.run_circle_outlined),
            label: 'myshare_status_status'.i18n()),
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.login), icon: const Icon(Icons.login), label: 'login_title'.i18n()),
      ];

  List<BottomNavigationBarItem> userScreens() => <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.run_circle_rounded),
            icon: const Icon(Icons.run_circle_outlined),
            label: 'myshare_status_status'.i18n()),
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.person_2_rounded),
            icon: const Icon(Icons.person_2_outlined),
            label: 'profile_title'.i18n()),
      ];

  List<BottomNavigationBarItem> adminScreens() => <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.run_circle_rounded),
            icon: const Icon(Icons.run_circle_outlined),
            label: 'myshare_status_status'.i18n()),
        BottomNavigationBarItem(
            activeIcon: const Icon(Icons.person_2_rounded),
            icon: const Icon(Icons.person_2_outlined),
            label: 'profile_title'.i18n()),
        const BottomNavigationBarItem(
            activeIcon: Icon(Icons.admin_panel_settings),
            icon: Icon(Icons.admin_panel_settings_outlined),
            label: 'Admin')
      ];

  @override
  FloatingActionButtonLocation setFloatingActionButtonLocation(WidgetRef ref) {
    UserModel? currentUser = ref.watch(userDataProvider);

    return currentUser != null && !currentUser.isUser()
        ? FloatingActionButtonLocation.centerFloat
        : FloatingActionButtonLocation.centerDocked;
  }
}
