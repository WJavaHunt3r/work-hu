import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/job_chat/data/model/job_chat_models.dart';
import 'package:work_hu/features/job_chat/providers/job_chat_provider.dart';
import 'package:work_hu/features/job_chat/view/job_chat_people_sheet.dart';

/// The chat room of a job. Everyone taking part gets a push for new messages unless they mute the chat. Once the
/// job is closed the chat is archived: it can be read but not written to.
class JobChatPage extends ConsumerStatefulWidget {
  const JobChatPage({super.key, required this.jobId});

  final num jobId;

  @override
  ConsumerState<JobChatPage> createState() => _JobChatPageState();
}

class _JobChatPageState extends ConsumerState<JobChatPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final problem = await ref.read(jobChatProvider(widget.jobId).notifier).send(text);
    if (problem == null) {
      _controller.clear();
    } else {
      showApiError(problem == "api_unknown_error" ? problem.i18n() : problem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jobChatProvider(widget.jobId));
    final notifier = ref.read(jobChatProvider(widget.jobId).notifier);
    final me = ref.read(userDataProvider).user;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("jobs_chat_title".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (state.error == null && !state.loading)
            IconButton(
              tooltip: "jobs_chat_people".i18n(),
              icon: const Icon(Icons.group_outlined),
              onPressed: () => showJobChatPeople(context, widget.jobId),
            ),
          if (state.error == null && !state.loading)
            IconButton(
              tooltip: (state.muted ? "jobs_chat_unmute" : "jobs_chat_mute").i18n(),
              icon: Icon(state.muted ? Icons.notifications_off_outlined : Icons.notifications_active_outlined),
              onPressed: () => notifier.setMuted(!state.muted),
            ),
        ],
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : state.error != null
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(24.sp),
                child: Text(
                  state.error == "api_unknown_error" ? state.error!.i18n() : state.error!,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Column(
              children: [
                if (state.muted)
                  Container(
                    width: double.infinity,
                    color: theme.colorScheme.surfaceContainerHighest,
                    padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 6.sp),
                    child: Text("jobs_chat_muted_hint".i18n(), style: theme.textTheme.bodySmall),
                  ),
                Expanded(child: _buildMessages(state, notifier, me?.id)),
                if (state.archived)
                  Container(
                    width: double.infinity,
                    color: theme.colorScheme.surfaceContainerHighest,
                    padding: EdgeInsets.all(16.sp),
                    child: SafeArea(
                      top: false,
                      child: Text(
                        "jobs_chat_archived".i18n(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  )
                else
                  _buildInput(state),
              ],
            ),
    );
  }

  Widget _buildMessages(JobChatState state, JobChatNotifier notifier, num? myId) {
    final theme = Theme.of(context);
    if (state.messages.isEmpty) {
      return Center(child: Text("jobs_chat_empty".i18n(), style: theme.textTheme.bodyMedium));
    }
    // Newest at the bottom: the list is reversed, so index 0 is the latest message.
    final reversed = state.messages.reversed.toList();
    final extra = state.hasOlder ? 1 : 0;
    return ListView.builder(
      reverse: true,
      padding: EdgeInsets.all(12.sp),
      itemCount: reversed.length + extra,
      itemBuilder: (context, index) {
        if (index == reversed.length) {
          return Center(
            child: TextButton(onPressed: notifier.loadOlder, child: Text("jobs_chat_load_older".i18n())),
          );
        }
        return _MessageBubble(message: reversed[index], mine: reversed[index].userId == myId);
      },
    );
  }

  Widget _buildInput(JobChatState state) {
    return Material(
      elevation: 4,
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: 2000,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(hintText: "jobs_chat_hint".i18n(), counterText: ""),
                ),
              ),
              SizedBox(width: 8.sp),
              IconButton.filled(
                onPressed: state.sending ? null : _send,
                icon: const Icon(Icons.send),
                tooltip: "jobs_chat_send".i18n(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.mine});

  final JobChatMessageModel message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final time = message.createDateTime == null ? "" : DateFormat("MM.dd HH:mm").format(message.createDateTime!);
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 3.sp),
        constraints: BoxConstraints(maxWidth: 0.78.sw),
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
        decoration: BoxDecoration(
          color: mine ? scheme.primaryContainer : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!mine)
              Text(
                message.userName,
                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: scheme.primary),
              ),
            SelectableText(message.text, style: theme.textTheme.bodyMedium),
            SizedBox(height: 2.sp),
            Align(
              alignment: Alignment.centerRight,
              child: Text(time, style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor)),
            ),
          ],
        ),
      ),
    );
  }
}
