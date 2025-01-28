import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/user_status/view/user_status_layout.dart';

class UserStatusPage extends BasePage {
  const UserStatusPage({super.key, super.title = "admin_myshare_status", super.isListView = true});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return const UserStatusLayout();
  }
}
