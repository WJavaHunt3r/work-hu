import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:work_hu/app/framework/base_components/main_screen.dart';
import 'package:work_hu/features/admin/view/admin_layout.dart';

class AdminPage extends MainScreen {
  const AdminPage(
      {super.key,
      super.title = "Admin",
      super.isListView = true,
      super.automaticallyImplyLeading = false,
      super.selectedIndex = 2});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return AdminLayout(key: key);
  }
}
