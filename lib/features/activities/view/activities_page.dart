import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/activities/view/activities_layout.dart';

class ActivitiesPage extends BasePage {
  ActivitiesPage({super.key, super.title = "admin_activities", super.isListView = true});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return const ActivitiesLayout();
  }
}
