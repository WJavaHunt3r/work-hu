import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/myshare_status/view/myshare_status_layout.dart';

class MyShareStatusPage extends BasePage {
  const MyShareStatusPage({super.key, super.title = "MyShare Status", required this.user});

  final UserModel user;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return MyShareStatusLayout(user: user);
  }
}
