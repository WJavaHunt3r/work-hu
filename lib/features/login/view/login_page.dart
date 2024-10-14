import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:work_hu/app/framework/base_components/main_screen.dart';
import 'package:work_hu/features/login/view/login_layout.dart';

class LoginPage extends MainScreen {
  LoginPage(
      {required this.origRoute,
      super.key,
      super.title = "DukApp",
      super.selectedIndex = 1,
      super.centerTitle = true,
      super.appBarTextStyle = const TextStyle(fontFamily: "Good-Timing", fontWeight: FontWeight.bold, fontSize: 35)});

  final String origRoute;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return LoginLayout(origRoute: origRoute);
  }
}
