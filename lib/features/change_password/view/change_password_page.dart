import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/change_password/provider/change_password_provider.dart';
import 'package:work_hu/features/change_password/view/change_password_layout.dart';

class ChangePasswordPage extends BasePage {
  const ChangePasswordPage({super.key, super.title = "change_password_viewname", super.canPop = false});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return const ChangePasswordLayout();
  }

  @override
  popInvoked(BuildContext context, bool value, WidgetRef ref) {
    ref.read(changePasswordDataProvider.notifier).clear(false, true);
  }
}
