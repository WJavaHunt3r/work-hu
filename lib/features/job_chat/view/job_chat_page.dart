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
        final message = reversed[index];
        return _MessageBubble(
          message: message,
          mine: message.userId == myId,
          onReact: state.archived ? null : (reaction) => _react(notifier, message, reaction),
        );
      },
    );
  }

  Future<void> _react(JobChatNotifier notifier, JobChatMessageModel message, JobChatReaction reaction) async {
    final problem = await notifier.toggleReaction(message, reaction);
    if (problem != null) showApiError(problem == "api_unknown_error" ? problem.i18n() : problem);
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
  const _MessageBubble({required this.message, required this.mine, this.onReact});

  final JobChatMessageModel message;
  final bool mine;

  /// Null in an archived chat: the counts are only shown.
  final ValueChanged<JobChatReaction>? onReact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final time = message.createDateTime == null ? "" : DateFormat("MM.dd HH:mm").format(message.createDateTime!);
    final showReactions = onReact != null || message.likes > 0 || message.dislikes > 0;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _bubble(context, theme, scheme, time),
          if (showReactions)
            Padding(
              padding: EdgeInsets.only(bottom: 4.sp),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ReactionChip(
                    icon: Icons.thumb_up_alt_outlined,
                    selectedIcon: Icons.thumb_up_alt,
                    count: message.likes,
                    selected: message.myReaction == JobChatReaction.like,
                    tooltip: "jobs_chat_like".i18n(),
                    onTap: onReact == null ? null : () => onReact!(JobChatReaction.like),
                  ),
                  SizedBox(width: 4.sp),
                  _ReactionChip(
                    icon: Icons.thumb_down_alt_outlined,
                    selectedIcon: Icons.thumb_down_alt,
                    count: message.dislikes,
                    selected: message.myReaction == JobChatReaction.dislike,
                    tooltip: "jobs_chat_dislike".i18n(),
                    onTap: onReact == null ? null : () => onReact!(JobChatReaction.dislike),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _bubble(BuildContext context, ThemeData theme, ColorScheme scheme, String time) {
    return Container(
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
    );
  }
}

/// A like or dislike button under a message with its count (hidden while 0); filled when it is the user's own.
class _ReactionChip extends StatelessWidget {
  const _ReactionChip({
    required this.icon,
    required this.selectedIcon,
    required this.count,
    required this.selected,
    required this.tooltip,
    this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final int count;
  final bool selected;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = selected ? scheme.primary : theme.hintColor;
    if (onTap == null && count == 0) return const SizedBox.shrink();
    return Tooltip(
      message: tooltip,
      child: Material(
        color: selected ? scheme.primaryContainer : Colors.transparent,
        shape: StadiumBorder(side: BorderSide(color: selected ? scheme.primary : scheme.outlineVariant)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 3.sp),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(selected ? selectedIcon : icon, size: 14.sp, color: color),
                if (count > 0) ...[
                  SizedBox(width: 4.sp),
                  Text("$count", style: theme.textTheme.labelSmall?.copyWith(color: color)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
