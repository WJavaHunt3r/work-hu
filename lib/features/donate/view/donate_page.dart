import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';

import 'donate_layout.dart';

class DonatePage extends BasePage {
  const DonatePage({super.key, required this.id, super.title = "donate"});

  final num id;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return DonateLayout(id: id);
  }
}
