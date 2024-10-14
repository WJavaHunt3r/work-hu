import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/features/create_activity/provider/create_activity_provider.dart';
import 'package:work_hu/features/create_activity/view/create_activity_layout.dart';

class CreateActivityPage extends BasePage {
  CreateActivityPage(
      {super.title = "create_activity_new_activity_viewname", super.key, super.canPop = false, isListView = true});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return ref.watch(createActivityDataProvider).modelState == ModelState.processing
        ? const Center(child: CircularProgressIndicator())
        : ref.watch(createActivityDataProvider).modelState == ModelState.error
            ? Text(ref.watch(createActivityDataProvider).errorMessage)
            : const CreateActivityLayout();
  }

  @override
  popInvoked(BuildContext context, bool didPop, WidgetRef ref) {
    if (!didPop) {
      showDialog(
          context: context,
          builder: (buildContext) {
            return ConfirmAlertDialog(
              onConfirm: () => buildContext.pop(true),
              title: "exit".i18n(),
              content: Text("create_activity_exit_warning".i18n()),
            );
          }).then((popped) => popped ?? false ? context.pop() : null);
    }
  }
}
