import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/rounds/provider/round_provider.dart';
import 'package:work_hu/features/rounds/view/rounds_layout.dart';

class RoundsPage extends BasePage {
  const RoundsPage({super.key, super.title = "rounds"});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return RoundsLayout();
  }

  @override
  List<Widget> buildActions(BuildContext context, WidgetRef ref) {
    return [IconButton(onPressed: () => ref.read(roundDataProvider.notifier).setPaceTeams(), icon: const Icon(Icons.refresh))];
  }
}
