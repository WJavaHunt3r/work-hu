import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/features/mentees/view/mentees_layout.dart';

class MenteesPage extends LegacyBasePage {
  const MenteesPage({super.key, super.title = "mentees_title"});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return const MenteesLayout();
  }
}
