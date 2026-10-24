import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/platform/adaptive.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/streams/data/model/stream_model.dart';
import 'package:work_hu/features/streams/providers/streams_provider.dart';
import 'package:work_hu/features/streams/view/live_languages.dart';

/// Admin → Streams: starts the Cloudflare live streams that are shown on the website, lists them with the address and
/// stream key to broadcast to, and deletes them. A new stream records automatically, which the notice after
/// starting reminds about.
class StreamsPage extends ConsumerStatefulWidget {
  const StreamsPage({super.key});

  @override
  ConsumerState<StreamsPage> createState() => _StreamsPageState();
}

class _StreamsPageState extends ConsumerState<StreamsPage> {
  final _title = TextEditingController();
  String _language = '';
  bool _busy = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final title = _title.text.trim();
    if (title.isEmpty) return;
    setState(() => _busy = true);
    try {
      await ref.read(streamRepoProvider).startStream(title, _language);
      _title.clear();
      ref.invalidate(streamsProvider);
      if (mounted) _showAudioNotice(context);
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _edit(StreamModel stream) async {
    final title = TextEditingController(text: stream.title);
    var language = stream.language;
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AdaptiveAlertDialog(
          title: Text("streams_edit_title".i18n()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                maxLength: 100,
                decoration: InputDecoration(labelText: "streams_stream_title".i18n(), counterText: ""),
              ),
              SizedBox(height: 12.sp),
              _LanguageField(value: language, onChanged: (v) => setDialogState(() => language = v)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text("base_cancel".i18n())),
            FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text("streams_save".i18n())),
          ],
        ),
      ),
    );
    final newTitle = title.text.trim();
    title.dispose();
    if (saved != true || newTitle.isEmpty) return;
    try {
      await ref.read(streamRepoProvider).updateStream(stream.uid, newTitle, language);
      ref.invalidate(streamsProvider);
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    }
  }

  Future<void> _delete(StreamModel stream) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AdaptiveAlertDialog(
        title: Text("streams_delete".i18n()),
        content: Text("streams_delete_question".i18n([stream.title])),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text("base_cancel".i18n())),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text("streams_delete".i18n())),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(streamRepoProvider).deleteStream(stream.uid);
      ref.invalidate(streamsProvider);
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final streams = ref.watch(streamsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("streams_title".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.invalidate(streamsProvider))],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async => ref.refresh(streamsProvider.future),
        child: ListView(
          padding: EdgeInsets.all(16.sp),
          children: [
            BaseContainer(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "streams_start".i18n(),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.sp),
                  TextField(
                    controller: _title,
                    maxLength: 100,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _start(),
                    decoration: InputDecoration(labelText: "streams_stream_title".i18n(), counterText: ""),
                  ),
                  SizedBox(height: 12.sp),
                  _LanguageField(value: _language, onChanged: (v) => setState(() => _language = v)),
                  SizedBox(height: 12.sp),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _busy ? null : _start,
                      icon: const Icon(Icons.play_circle_outline),
                      label: Text("streams_start_button".i18n()),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.sp),
            Text("streams_available".i18n(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.sp),
            streams.when(
              loading: () => Padding(
                padding: EdgeInsets.all(24.sp),
                child: const Center(child: CircularProgressIndicator.adaptive()),
              ),
              error: (error, _) => Padding(
                padding: EdgeInsets.all(16.sp),
                child: Text(error is ApiException ? error.message : "api_unknown_error".i18n()),
              ),
              data: (list) => list.isEmpty
                  ? Padding(padding: EdgeInsets.all(16.sp), child: Text("streams_none".i18n()))
                  : Column(
                      children: [
                        for (final stream in list)
                          _StreamCard(stream: stream, onEdit: () => _edit(stream), onDelete: () => _delete(stream)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreamCard extends StatefulWidget {
  const _StreamCard({required this.stream, required this.onEdit, required this.onDelete});

  final StreamModel stream;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_StreamCard> createState() => _StreamCardState();
}

class _StreamCardState extends State<_StreamCard> {
  bool _showKey = false;

  Future<void> _copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("streams_copied".i18n())));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stream = widget.stream;
    final key = stream.streamKey.isEmpty ? "N/A" : (_showKey ? stream.streamKey : "•" * 16);
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: BaseContainer(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(stream.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: "streams_edit".i18n(),
                  onPressed: widget.onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                  tooltip: "streams_delete".i18n(),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
            if (stream.language.isNotEmpty)
              Text(
                liveLanguageName(stream.language),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              ),
            if (stream.rtmpsUrl.isNotEmpty)
              _line(theme, "streams_rtmps_url".i18n(), stream.rtmpsUrl, () => _copy(stream.rtmpsUrl)),
            _line(
              theme,
              "streams_stream_key".i18n(),
              key,
              stream.streamKey.isEmpty ? null : () => _copy(stream.streamKey),
              extra: stream.streamKey.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(_showKey ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20.sp),
                      tooltip: (_showKey ? "streams_hide_key" : "streams_show_key").i18n(),
                      onPressed: () => setState(() => _showKey = !_showKey),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(ThemeData theme, String label, String value, VoidCallback? onCopy, {Widget? extra}) {
    return Padding(
      padding: EdgeInsets.only(top: 8.sp),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.hintColor)),
                SelectableText(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          ?extra,
          if (onCopy != null)
            IconButton(
              icon: Icon(Icons.copy_outlined, size: 20.sp),
              tooltip: "jobs_calendar_copy".i18n(),
              onPressed: onCopy,
            ),
        ],
      ),
    );
  }
}

/// The language of a stream's audio: one of [liveLanguages], or not set.
class _LanguageField extends StatelessWidget {
  const _LanguageField({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: liveLanguages.containsKey(value) ? value : '',
      decoration: InputDecoration(labelText: "streams_language".i18n()),
      items: [
        DropdownMenuItem(value: '', child: Text("streams_language_none".i18n())),
        for (final e in liveLanguages.entries) DropdownMenuItem(value: e.key, child: Text(e.value)),
      ],
      onChanged: (v) => onChanged(v ?? ''),
    );
  }
}

/// The blinking "Audio recording!!" notice after starting a stream (like the old tool): it goes away by itself after
/// five seconds, or on a tap.
void _showAudioNotice(BuildContext context) {
  showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: "streams_audio_notice".i18n(),
    barrierColor: Colors.black54,
    pageBuilder: (dialogContext, _, _) => _AudioNotice(
      onDone: () {
        if (dialogContext.mounted) Navigator.of(dialogContext).maybePop();
      },
    ),
  );
}

class _AudioNotice extends StatefulWidget {
  const _AudioNotice({required this.onDone});

  final VoidCallback onDone;

  @override
  State<_AudioNotice> createState() => _AudioNoticeState();
}

class _AudioNoticeState extends State<_AudioNotice> with SingleTickerProviderStateMixin {
  late final AnimationController _blink = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
    ..repeat(reverse: true);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 5), widget.onDone);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _blink,
        child: Text(
          "streams_audio_notice".i18n(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontSize: 40.sp,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
