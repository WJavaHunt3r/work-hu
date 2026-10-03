import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/mentor_mentee/data/model/mentor_mentee_model.dart';
import 'package:work_hu/features/mentor_mentee/provider/mentor_mentee_provider.dart';
import 'package:work_hu/features/mentor_mentee/widgets/create_mentor_mentee_dialog.dart';
import 'package:work_hu/features/utils.dart';

class MentorMenteesPage extends BaseListPage {
  const MentorMenteesPage({super.key, super.title = "admin_mentor_mentees"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return MentorMenteesPageState();
  }
}

class MentorMenteesPageState
    extends PagedListPageState<MentorMenteesPage, MentorMenteeModel, void, MentorMenteeDataNotifier> {
  @override
  get provider => mentorMenteeDataProvider;

  @override
  Widget build(BuildContext context) {
    // Keeps the create dialog's state alive, and reports its errors, which the base page doesn't.
    ref.listen(mentorMenteeCreateProvider, (previous, next) {
      if (next.status.modelState.isError && !(previous?.status.modelState.isError ?? false)) {
        Utils.showErrorDialog(context, content: next.status.message.i18n());
      }
    });
    return super.build(context);
  }

  @override
  Widget buildListTile(MentorMenteeModel item, int index) {
    return BaseListTile(
      isLast: items.length - 1 == index,
      index: index,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(item.mentor.getFullName()), Text(item.mentee.getFullName())],
      ),
    );
  }

  @override
  bool canDelete(MentorMenteeModel item) => true;

  @override
  void onDelete(MentorMenteeModel item) => notifier.deleteMentee(item.id!);

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) => const CreateMentorMenteeDialog(),
      ).then((saved) => saved == true ? notifier.reload() : null),
    );
  }
}
