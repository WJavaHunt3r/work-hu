import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/users/view/users_layout.dart';

class UsersPage extends BasePage {
  const UsersPage({super.key, super.title = "Users"});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return const UsersLayout();
  }
}
