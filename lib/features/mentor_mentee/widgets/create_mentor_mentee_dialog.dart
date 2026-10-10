import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/mentor_mentee/provider/mentor_mentee_provider.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/user_combo/view/user_combo.dart';
import 'package:work_hu/app/platform/adaptive.dart';

class CreateMentorMenteeDialog extends ConsumerWidget {
  const CreateMentorMenteeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mentorMenteeCreateProvider);
    final notifier = ref.read(mentorMenteeCreateProvider.notifier);
    return AdaptiveAlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            notifier.clearCreation();
            Navigator.of(context).pop();
          },
          child: Text("base_cancel".i18n()),
        ),
        FilledButton(
          // postMentee needs both users.
          onPressed: state.mentor == null || state.mentee == null
              ? null
              : () async {
                  final saved = await notifier.postMentee();
                  if (context.mounted) Navigator.of(context).pop(saved);
                },
          child: Text("base_save".i18n()),
        ),
      ],
      // AlertDialog sizes its content with IntrinsicWidth, which the user picker's LayoutBuilder can't answer;
      // a fixed width means the content is never asked.
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserComboWidget(
              controller: notifier.mentorController,
              labelText: "mentor_mentee_mentor".i18n(),
              onSuggestionSelected: (UserComboModel user) => notifier.selectMentor(user.id),
            ),
            UserComboWidget(
              controller: notifier.menteeController,
              labelText: "mentor_mentee_mentee".i18n(),
              onSuggestionSelected: (UserComboModel user) => notifier.selectMentee(user.id),
            ),
          ],
        ),
      ),
    );
  }
}
