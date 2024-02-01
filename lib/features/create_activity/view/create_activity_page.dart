import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/features/create_activity/provider/create_activity_provider.dart';
import 'package:work_hu/features/create_activity/view/create_activity_layout.dart';

class CreateActivityPage extends BasePage {
  const CreateActivityPage({super.title = "New Activity", super.key, super.canPop = false});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: ref.watch(createActivityDataProvider).modelState == ModelState.processing
              ? const Center(child: CircularProgressIndicator())
              : ref.watch(createActivityDataProvider).modelState == ModelState.error
                  ? Text(ref.watch(createActivityDataProvider).errorMessage)
                  : const CreateActivityLayout(),
        )
      ],
    );
  }

  @override
  popInvoked(BuildContext context, bool value, WidgetRef ref) {
    showDialog(
        context: context,
        builder: (context) {
          return ConfirmAlertDialog(
              onConfirm: () => context.pop(true),
              title: "Exit",
              content: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("All data will be lost!"),
                ],
              ));
        }).then((popped) => popped ?? false ? context.pop() : null);
  }
}
