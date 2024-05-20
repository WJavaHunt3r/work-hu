import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/widgets/work_drop_down_dearch_form_field.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/mentor_mentee/provider/mentor_mentee_provider.dart';

class CreateMentorMenteeDialog extends ConsumerWidget {
  const CreateMentorMenteeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      actions: [
        TextButton(
            onPressed: () {
              ref.read(mentorMenteeDataProvider.notifier).clearCreation();
              context.pop();
            },
            child: const Text("cancel")),
        TextButton(
            onPressed: () => ref.watch(mentorMenteeDataProvider.notifier).postMentee().then((value) => context.pop()),
            child: const Text("Create"))
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Mentor"),
          WorkDropDownSearchFormField<UserModel>(
            direction: AxisDirection.up,
            controller: ref.read(mentorMenteeDataProvider.notifier).mentorController,
            onSuggestionSelected: (UserModel suggestion) =>
                ref.read(mentorMenteeDataProvider.notifier).updateSelection(mentor: suggestion),
            itemBuilder: (context, data) => Text("${data.getFullName()} (${data.getAge()})"),
            suggestionsCallback: (String pattern) => ref.read(mentorMenteeDataProvider.notifier).filterUsers(pattern),
          ),
          const Text("Mentee"),
          WorkDropDownSearchFormField<UserModel>(
            direction: AxisDirection.up,
            controller: ref.read(mentorMenteeDataProvider.notifier).menteeController,
            onSuggestionSelected: (UserModel suggestion) =>
                ref.read(mentorMenteeDataProvider.notifier).updateSelection(mentee: suggestion),
            itemBuilder: (context, data) => Text("${data.getFullName()} (${data.getAge()})"),
            suggestionsCallback: (String pattern) => ref.read(mentorMenteeDataProvider.notifier).filterUsers(pattern),
          ),
        ],
      ),
    );
  }
}
