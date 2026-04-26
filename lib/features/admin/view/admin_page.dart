import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/admin/view/admin_layout.dart';

class AdminPage extends BasePage {
  const AdminPage({super.key, super.title = "Admin", super.isListView = true, super.automaticallyImplyLeading = false});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return AdminLayout(key: key);
  }
}
