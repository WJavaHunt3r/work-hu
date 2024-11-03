import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/fra_kare_week/view/fra_kare_week_layout.dart';

class FraKareWeekPage extends BasePage {
  FraKareWeekPage({super.key, super.title = "admin_fra_kare_weeks"});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return FraKareWeekLayout(
      key: key,
    );
  }
}
