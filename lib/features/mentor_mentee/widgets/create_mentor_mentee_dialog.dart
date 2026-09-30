import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/mentor_mentee/provider/mentor_mentee_provider.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/user_combo/view/user_combo.dart';

class CreateMentorMenteeDialog extends ConsumerWidget {
  const CreateMentorMenteeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            ref.read(mentorMenteeCreateProvider.notifier).clearCreation();
            context.pop();
          },
          child: const Text("cancel"),
        ),
        TextButton(
          onPressed: () async {
            final saved = await ref.read(mentorMenteeCreateProvider.notifier).postMentee();
            if (context.mounted) context.pop(saved);
          },
          child: const Text("Create"),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserComboWidget(
            controller: ref.read(mentorMenteeCreateProvider.notifier).mentorController,
            onSuggestionSelected: (UserComboModel suggestion) => null,
            // ref.read(mentorMenteeCreateProvider.notifier).updateSelection(mentor: suggestion),
            // itemBuilder: (context, data) => Text("${data.getFullName()} (${data.getAge()})"),
            // suggestionsCallback: (String pattern) => ref.read(mentorMenteeCreateProvider.notifier).filterUsers(pattern),
            labelText: 'mentor_mentee_mentor'.i18n(),
          ),
          UserComboWidget(
            labelText: "mentor_mentee_mentor".i18n(),
            controller: ref.read(mentorMenteeCreateProvider.notifier).menteeController,
            onSuggestionSelected: (UserComboModel suggestion) => null,
            // ref.read(mentorMenteeCreateProvider.notifier).updateSelection(mentee: suggestion),
            // itemBuilder: (context, data) => Text("${data.getFullName()} (${data.getAge()})"),
            // suggestionsCallback: (String pattern) => ref.read(mentorMenteeCreateProvider.notifier).filterUsers(pattern),
          ),
        ],
      ),
    );
  }
}
