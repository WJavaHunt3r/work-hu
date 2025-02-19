import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/features/create_activity/provider/create_activity_provider.dart';
import 'package:work_hu/features/create_activity/widgets/registration_row_widget.dart';

class ActivityRegistrationListCard extends ConsumerWidget {
  const ActivityRegistrationListCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var items = ref.watch(createActivityDataProvider).activityItems;
    return BaseListView(
      itemCount: ref.watch(createActivityDataProvider).activityItems.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        var user = items[index].user;
        return RegistrationRowWidget(
            name: user.getFullName(),
            index: index,
            isLast: index == ref.watch(createActivityDataProvider).activityItems.length - 1,
            value: items[index].hours);
      },
      children: [],
    );
  }
}
