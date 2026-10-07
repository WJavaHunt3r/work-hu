import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/features/job_chat/data/model/job_chat_models.dart';
import 'package:work_hu/features/job_chat/providers/job_chat_provider.dart';
import 'package:work_hu/features/jobs/widgets/user_filter_chip.dart';

/// Opens the list of everyone in the chat of [jobId]. Organisers can add people who aren't registered for the job
/// (they only get the chat) and remove those again; registered people leave by cancelling their registration.
Future<void> showJobChatPeople(BuildContext context, num jobId) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _JobChatPeopleSheet(jobId: jobId),
);

class _JobChatPeopleSheet extends ConsumerStatefulWidget {
  const _JobChatPeopleSheet({required this.jobId});

  final num jobId;

  @override
  ConsumerState<_JobChatPeopleSheet> createState() => _JobChatPeopleSheetState();
}

class _JobChatPeopleSheetState extends ConsumerState<_JobChatPeopleSheet> {
  JobChatPeopleModel? _people;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final people = await ref.read(jobChatRepoProvider).getPeople(widget.jobId);
      if (mounted) setState(() => _people = people);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = "api_unknown_error".i18n());
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
      await _load();
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    }
  }

  Future<void> _add() async {
    final user = await showDialog(
      context: context,
      builder: (_) => const UserSearchDialog(title: "jobs_chat_add_person"),
    );
    if (user == null) return;
    await _run(() => ref.read(jobChatRepoProvider).addMember(widget.jobId, user.id));
  }

  String _roleLabel(String role) => "jobs_chat_role_$role".i18n();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final people = _people;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 0.8.sh),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.sp, 0, 16.sp, 16.sp),
          child: _error != null
              ? Padding(padding: EdgeInsets.all(24.sp), child: Text(_error!))
              : people == null
              ? Padding(
                  padding: EdgeInsets.all(24.sp),
                  child: const Center(child: CircularProgressIndicator()),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "jobs_chat_people".i18n(),
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.sp),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (final person in people.participants)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(person.userName),
                              subtitle: Text(_roleLabel(person.role)),
                              trailing: person.removable && people.canManage
                                  ? IconButton(
                                      icon: const Icon(Icons.person_remove_outlined),
                                      tooltip: "jobs_chat_remove_person".i18n(),
                                      onPressed: () => _run(
                                        () => ref.read(jobChatRepoProvider).removeMember(widget.jobId, person.userId),
                                      ),
                                    )
                                  : null,
                            ),
                        ],
                      ),
                    ),
                    if (people.canManage) ...[
                      SizedBox(height: 8.sp),
                      FilledButton.icon(
                        onPressed: _add,
                        icon: const Icon(Icons.person_add_alt),
                        label: Text("jobs_chat_add_person".i18n()),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
