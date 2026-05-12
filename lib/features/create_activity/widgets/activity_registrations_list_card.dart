import 'dart:math';

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
      physics: const NeverScrollableScrollPhysics(),
      children: items.map((e) {
        var user = e.userName;
        return RegistrationRowWidget(
            name: user,
            index: items.indexOf(e),
            isLast: items.indexOf(e) == ref.watch(createActivityDataProvider).activityItems.length - 1,
            value: e.hours);
      }).toList(),
    );
  }
}
