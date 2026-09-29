import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_state.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/mentor_mentee/data/model/mentor_mentee_model.dart';
import 'package:work_hu/features/mentor_mentee/data/state/mentor_mentee_state.dart';
import 'package:work_hu/features/mentor_mentee/provider/mentor_mentee_provider.dart';
import 'package:work_hu/features/mentor_mentee/widgets/create_mentor_mentee_dialog.dart';

class MentorMenteesPage extends BaseListPage {
  const MentorMenteesPage({super.key, super.title = "admin_mentor_mentees"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return MentorMenteesPageState();
  }
}

class MentorMenteesPageState extends BaseListPageState<MentorMenteesPage, MentorMenteeState, MentorMenteeDataNotifier> {
  @override
  Widget buildListTile(item) {
    item as MentorMenteeModel;
    var index = items.indexOf(item);
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
  bool canDelete(item) => true;

  @override
  onDelete(e) {
    ref.read(mentorMenteeDataProvider.notifier).deleteMentee(e.id!);
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const CreateMentorMenteeDialog(),
      ),
    );
  }

  @override
  List<dynamic> getFilters() {
    return [];
  }

  @override
  List<dynamic> get items => state.mentees;

  @override
  BaseListState get listStatus => state.listState;

  @override
  StateNotifierProvider<MentorMenteeDataNotifier, MentorMenteeState> get provider => mentorMenteeDataProvider;
}
