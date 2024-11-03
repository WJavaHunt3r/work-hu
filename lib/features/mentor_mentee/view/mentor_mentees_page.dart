import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/mentor_mentee/view/mentor_mentee_layout.dart';

class MentorMenteesPage extends BasePage {
  MentorMenteesPage({super.key, super.title = "admin_mentor_mentees"});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return MentorMenteeLayout(key: key);
  }
}
