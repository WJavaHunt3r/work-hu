import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/list_card.dart';
import 'package:work_hu/features/mentor_mentee/provider/mentor_mentee_provider.dart';
import 'package:work_hu/features/mentor_mentee/widgets/create_mentor_mentee_dialog.dart';

class MentorMenteeLayout extends ConsumerWidget {
  const MentorMenteeLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var items = ref.watch(mentorMenteeDataProvider).mentees;
    var state = ref.watch(mentorMenteeDataProvider).modelState;
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                  onRefresh: () async => ref.read(mentorMenteeDataProvider.notifier).getMentorMentee(),
                  child: BaseListView(
                    cardBackgroundColor: Colors.transparent,
                      itemBuilder: (context, index) {
                        var current = items[index];
                        return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) =>
                                ref.watch(mentorMenteeDataProvider.notifier).deleteMentee(current.id!),
                            dismissThresholds: const <DismissDirection, double>{DismissDirection.endToStart: 0.4},
                            child: ListCard(
                                isLast: items.length - 1 == index,
                                index: index,
                                child: ListTile(
                                    title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [Text(current.mentor.getFullName()), Text(current.mentee.getFullName())],
                                ))));
                      },
                      itemCount: items.length,
                      children: const [])),
            ),
          ],
        ),
        Positioned(
          bottom: 20.sp,
          right: 20.sp,
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => const CreateMentorMenteeDialog());
            },
          ),
        ),
        state == ModelState.processing
            ? const AlertDialog(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                content: Column(
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                ))
            : const SizedBox()
      ],
    );
  }
}
