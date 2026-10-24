import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/platform/adaptive.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/mailing/data/api/mailing_api.dart';
import 'package:work_hu/features/mailing/data/model/mailing_models.dart';
import 'package:work_hu/features/mailing/data/repository/mailing_repository.dart';

final mailingRepoProvider = Provider<MailingRepository>((ref) => MailingRepository(MailingApi()));

/// How many members the next mailing reaches.
final mailingRecipientsProvider = FutureProvider.autoDispose<MailingRecipientsModel>(
  (ref) => ref.read(mailingRepoProvider).getRecipients(),
);

/// Admin → Mailing: an e-mail to all members, written in a rich text box. It is sent from the mailing mailbox, not
/// the one of the status e-mails, with the members in blind copy. "Send test to me" shows how it will look first.
class MailingPage extends ConsumerStatefulWidget {
  const MailingPage({super.key});

  @override
  ConsumerState<MailingPage> createState() => _MailingPageState();
}

class _MailingPageState extends ConsumerState<MailingPage> {
  final _subject = TextEditingController();
  final _body = QuillController.basic();
  final _focus = FocusNode();
  final _scroll = ScrollController();
  bool _busy = false;

  @override
  void dispose() {
    _subject.dispose();
    _body.dispose();
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  bool get _bodyEmpty => _body.document.toPlainText().trim().isEmpty;

  /// The message as e-mail HTML (inline styles, as mail apps ignore style sheets). The server cleans it again.
  String _html() {
    final ops = List<Map<String, dynamic>>.from(_body.document.toDelta().toJson());
    return QuillDeltaToHtmlConverter(ops, ConverterOptions.forEmail()).convert();
  }

  bool _ready() {
    if (_subject.text.trim().isEmpty || _bodyEmpty) {
      showApiError("mailing_missing".i18n());
      return false;
    }
    return true;
  }

  Future<void> _sendTest() async {
    if (!_ready()) return;
    setState(() => _busy = true);
    try {
      await ref.read(mailingRepoProvider).sendTest(_subject.text.trim(), _html());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("mailing_test_sent".i18n())));
      }
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _send(int count) async {
    if (!_ready()) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AdaptiveAlertDialog(
        title: Text("mailing_send".i18n()),
        content: Text("mailing_send_question".i18n(["$count"])),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text("base_cancel".i18n())),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text("mailing_send".i18n())),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    try {
      final mailing = await ref.read(mailingRepoProvider).send(_subject.text.trim(), _html());
      _subject.clear();
      _body.clear();
      ref.invalidate(mailingRecipientsProvider);
      if (mounted) {
        final key = mailing.failedCount == 0 ? "mailing_sent" : "mailing_sent_with_failures";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(key.i18n(["${mailing.recipientCount - mailing.failedCount}", "${mailing.failedCount}"])),
            duration: const Duration(seconds: 8),
          ),
        );
      }
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recipients = ref.watch(mailingRecipientsProvider);
    final count = recipients.value?.count ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("mailing_title".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: "mailing_history".i18n(),
            onPressed: () => context.push("/admin/mailing/history"),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.sp),
        children: [
          BaseContainer(
            padding: EdgeInsets.all(16.sp),
            color: theme.colorScheme.primaryContainer,
            child: recipients.when(
              loading: () => const Center(child: CircularProgressIndicator.adaptive()),
              error: (error, _) => Text(error is ApiException ? error.message : "api_unknown_error".i18n()),
              data: (r) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "mailing_recipients".i18n(["${r.count}"]),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  SizedBox(height: 4.sp),
                  Text(
                    "mailing_recipients_hint".i18n(["${r.members}"]),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                  ),
                  if (r.withoutEmail > 0) ...[
                    SizedBox(height: 8.sp),
                    Text(
                      "mailing_without_email".i18n(["${r.withoutEmail}"]),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    Text(
                      r.withoutEmailNames.join(", "),
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: 16.sp),
          TextField(
            controller: _subject,
            maxLength: 200,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: "mailing_subject".i18n(), counterText: ""),
          ),
          SizedBox(height: 12.sp),
          QuillSimpleToolbar(
            controller: _body,
            config: const QuillSimpleToolbarConfig(
              multiRowsDisplay: true,
              showFontFamily: false,
              showFontSize: false,
              showSubscript: false,
              showSuperscript: false,
              showInlineCode: false,
              showCodeBlock: false,
              showSearchButton: false,
              showIndent: false,
              showDirection: false,
              showQuote: true,
              showListCheck: false,
            ),
          ),
          SizedBox(height: 8.sp),
          Container(
            height: 320.sp,
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(12.sp),
            ),
            child: QuillEditor(
              controller: _body,
              focusNode: _focus,
              scrollController: _scroll,
              config: QuillEditorConfig(placeholder: "mailing_body_hint".i18n(), expands: true),
            ),
          ),
          SizedBox(height: 16.sp),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : _sendTest,
                  icon: const Icon(Icons.outgoing_mail),
                  label: Text("mailing_test".i18n()),
                ),
              ),
              SizedBox(width: 12.sp),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _busy || count == 0 ? null : () => _send(count),
                  icon: const Icon(Icons.send),
                  label: Text("mailing_send".i18n()),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.sp),
        ],
      ),
    );
  }
}
