import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/login/view/login_layout.dart';

class LoginPage extends BasePage {
  const LoginPage({super.key, super.title = "login_title"});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return const LoginLayout();
  }
}
