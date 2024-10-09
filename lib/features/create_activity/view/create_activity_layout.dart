import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/success_alert_dialog.dart';
import 'package:work_hu/features/create_activity/provider/create_activity_provider.dart';
import 'package:work_hu/features/create_activity/widgets/activity_registrations_list_card.dart';
import 'package:work_hu/features/create_activity/widgets/activity_sum_card.dart';
import 'package:work_hu/features/create_activity/widgets/add_registration_card.dart';
import 'package:work_hu/features/create_activity/widgets/collapsable_details_layout.dart';

class CreateActivityLayout extends ConsumerWidget {
  const CreateActivityLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future(() => ref.read(createActivityDataProvider).creationState == ModelState.success
        ? showDialog(
            context: context,
            builder: (context) {
              return SuccessAlertDialog(title: "create_activity_create_success".i18n());
            })
        : null);
    return Column(
      children: [
        const CollapsableDetailsLayout(),
        Expanded(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: ref.watch(createActivityDataProvider).description.isEmpty
                  ? []
                  : enabledWidgets(context, ref)),
        ),
      ],
    );
  }

  List<Widget> enabledWidgets(BuildContext context, WidgetRef ref) {
    var items = ref.watch(createActivityDataProvider).activityItems;
    return [
      ActivitySumCard(items: items),
      const AddRegistrationCard(),
      const ActivityRegistrationListCard()
    ];
  }
}
