import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/dukapp.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

abstract class MainScreen extends BasePage {
  const MainScreen(
      {required this.selectedIndex,
      super.key,
      required super.title,
      super.isListView,
      super.appBarTextStyle,
      super.extendBodyBehindAppBar,
      super.automaticallyImplyLeading = false,
      super.centerTitle});

  final int selectedIndex;

  @override
  buildBottomNavigationBar(BuildContext context, WidgetRef ref) {
    UserModel? currentUser = ref.watch(userDataProvider);
    return BottomNavigationBar(
        items: currentUser == null
            ? noUserScreens(selectedIndex)
            : currentUser.isUser()
                ? userScreens(selectedIndex)
                : adminScreens(selectedIndex),
        currentIndex: selectedIndex,
        selectedFontSize: 16,
        onTap: (int index) => _onItemTapped(index, ref, currentUser));
  }

  void _onItemTapped(int index, WidgetRef ref, UserModel? currentUser) {
    if (index != selectedIndex) {
      if (index == 0) {
        ref.watch(routerProvider).replace("/home");
      }
      if (index == 1) {
        if (currentUser == null) {
          ref.watch(routerProvider).replace("/login");
        } else {
          ref.watch(routerProvider).replace("/profile");
        }
      }
      if (index == 2) {
        ref.watch(routerProvider).replace("/admin");
      }
    }
  }

  List<BottomNavigationBarItem> noUserScreens(num selected) => <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(selected == 0 ? Icons.run_circle_rounded : Icons.run_circle_outlined),
            label: 'myshare_status_status'.i18n()),
        BottomNavigationBarItem(
            icon: selected == 1 ? const Icon(Icons.login) : const Icon(Icons.login), label: 'login_title'.i18n()),
      ];

  List<BottomNavigationBarItem> userScreens(num selected) => <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(selected == 0 ? Icons.run_circle_rounded : Icons.run_circle_outlined),
            label: 'myshare_status_status'.i18n()),
        BottomNavigationBarItem(
            icon: selected == 1 ? const Icon(Icons.person_2) : const Icon(Icons.person_2_outlined),
            label: 'profile_title'.i18n()),
      ];

  List<BottomNavigationBarItem> adminScreens(num selected) => <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(selected == 0 ? Icons.run_circle_rounded : Icons.run_circle_outlined),
            label: 'myshare_status_status'.i18n()),
        BottomNavigationBarItem(
            icon: selected == 1 ? const Icon(Icons.person_2) : const Icon(Icons.person_2_outlined),
            label: 'profile_title'.i18n()),
        BottomNavigationBarItem(
            icon: selected == 2
                ? const Icon(Icons.admin_panel_settings)
                : const Icon(Icons.admin_panel_settings_outlined),
            label: 'Admin')
      ];
}
