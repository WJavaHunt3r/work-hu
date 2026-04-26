import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/login/view/login_layout.dart';

class LoginPage extends BasePage {
  const LoginPage({
    required this.origRoute,
    super.key,
    super.title = "",

    // super.extendBodyBehindAppBar = true,
    // super.centerTitle = true,
    // super.appBarTextStyle = const TextStyle(fontFamily: "Good-Timing", fontWeight: FontWeight.bold, fontSize: 35)
  });

  final String origRoute;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return LoginLayout(origRoute: origRoute);
  }
}
