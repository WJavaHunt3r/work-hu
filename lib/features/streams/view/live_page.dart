import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/profile/view/profile_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/streams/data/model/live_stream_model.dart';
import 'package:work_hu/features/streams/providers/streams_provider.dart';
import 'package:work_hu/features/streams/view/live_audio_stub.dart'
    if (dart.library.js_interop) 'package:work_hu/features/streams/view/live_audio_web.dart';
import 'package:work_hu/features/streams/view/live_frame_stub.dart'
    if (dart.library.js_interop) 'package:work_hu/features/streams/view/live_frame_web.dart';
import 'package:work_hu/features/streams/view/live_languages.dart';
import 'package:work_hu/features/streams/view/live_player.dart';

/// The Live tab: every broadcast that is on the air, one chip per language, and the player. "Audio only" switches the
/// picture off (apps: plays with the screen off too).
///
/// When the encoder loses its connection the stream drops out of the list for a while; the page keeps the chosen
/// stream and its player, which reconnect by themselves, and only gives up after [_giveUpAfter].
class LivePage extends ConsumerStatefulWidget {
  const LivePage({super.key});

  @override
  ConsumerState<LivePage> createState() => _LivePageState();
}

class _LivePageState extends ConsumerState<LivePage> {
  static const _giveUpAfter = Duration(minutes: 3);
  static const _languageKey = 'live_language';
  static const _audioKey = 'live_audio_only';

  LiveStreamModel? _current;
  DateTime? _missingSince;
  bool _audioOnly = false;
  String _preferredLanguage = '';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _preferredLanguage = prefs.getString(_languageKey) ?? '';
        _audioOnly = prefs.getBool(_audioKey) ?? false;
        // Re-pick with the remembered language, unless the user already chose
        if (_current != null && _current!.language != _preferredLanguage) _current = null;
      });
    } catch (_) {
      // The page works without remembered choices
    }
  }

  Future<void> _remember(String key, Object value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
    } catch (_) {
      // not remembered
    }
  }

  void _select(LiveStreamModel stream) {
    setState(() {
      _current = stream;
      _missingSince = null;
      _preferredLanguage = stream.language;
    });
    _remember(_languageKey, stream.language);
  }

  /// Keeps [_current] in step with the list: updated while it is on the air, kept while briefly missing, replaced
  /// when it is gone for good or nothing was chosen yet.
  void _sync(List<LiveStreamModel> live) {
    final current = _current;
    if (current != null) {
      final match = live.where((s) => s.uid == current.uid);
      if (match.isNotEmpty) {
        _current = match.first;
        _missingSince = null;
        return;
      }
      _missingSince ??= DateTime.now();
      if (DateTime.now().difference(_missingSince!) < _giveUpAfter) return;
    }
    if (live.isEmpty) return;
    _current = live.firstWhere((s) => s.language == _preferredLanguage, orElse: () => live.first);
    _missingSince = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final live = ref.watch(liveStreamsProvider).value ?? const <LiveStreamModel>[];
    _sync(live);
    final current = _current;
    final interrupted = current != null && _missingSince != null;
    final chips = [...live, if (current != null && live.every((s) => s.uid != current.uid)) current];
    final gone = current != null && interrupted && DateTime.now().difference(_missingSince!) >= _giveUpAfter;

    return Scaffold(
      appBar: AppBar(
        leading: const ProfileAvatarButton(),
        title: Text("live_title".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.sp),
        children: [
          if (current == null || gone)
            BaseContainer(
              padding: EdgeInsets.all(24.sp),
              child: Column(
                children: [
                  Icon(Icons.live_tv_outlined, size: 48.sp, color: theme.hintColor),
                  SizedBox(height: 12.sp),
                  Text(
                    (gone ? "live_ended" : "live_none").i18n(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            )
          else ...[
            if (chips.length > 1) ...[
              Text("live_language".i18n(), style: theme.textTheme.labelLarge?.copyWith(color: theme.hintColor)),
              SizedBox(height: 8.sp),
              Wrap(
                spacing: 8.sp,
                runSpacing: 8.sp,
                children: [
                  for (final s in chips)
                    ChoiceChip(
                      label: Text(s.language.isEmpty ? s.title : liveLanguageName(s.language)),
                      selected: s.uid == current.uid,
                      onSelected: (_) => _select(s),
                    ),
                ],
              ),
              SizedBox(height: 16.sp),
            ],
            Text(current.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            if (current.language.isNotEmpty)
              Text(
                liveLanguageName(current.language),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              ),
            SizedBox(height: 12.sp),
            if (interrupted)
              Padding(
                padding: EdgeInsets.only(bottom: 12.sp),
                child: Row(
                  children: [
                    SizedBox(width: 16.sp, height: 16.sp, child: const CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 8.sp),
                    Expanded(child: Text("live_reconnecting".i18n())),
                  ],
                ),
              ),
            if (kIsWeb)
              // Audio only is a plain audio element (the embedded page can't hide its picture, and a video page stops in the
              // background); the video mode is Cloudflare's embedded player
              _audioOnly
                  ? buildLiveWebAudio(hlsUrl: current.hlsUrl, title: current.title)
                  : AspectRatio(aspectRatio: 16 / 9, child: buildLiveFrame(current.iframeUrl))
            else
              LivePlayer(stream: current, audioOnly: _audioOnly),
            SizedBox(height: 8.sp),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.headphones),
              title: Text("live_audio_only".i18n()),
              subtitle: Text(liveAudioOnlyHintKey().i18n()),
              value: _audioOnly,
              onChanged: (value) {
                setState(() => _audioOnly = value);
                _remember(_audioKey, value);
              },
            ),
          ],
        ],
      ),
    );
  }
}

/// The hint under the audio-only switch: the apps (iOS and Android) keep playing with the screen off, the web page does it in audio-only mode (an audio element), not in video mode.
String liveAudioOnlyHintKey() => kIsWeb ? "live_audio_only_hint_short" : "live_audio_only_hint";

/// A readable text colour on [background]. The theme's own `onErrorContainer` can't be trusted: the dark theme sets a light
/// `errorContainer` but keeps a light `onErrorContainer`, which made the banner's text invisible.
Color liveBannerForeground(Color background) =>
    ThemeData.estimateBrightnessForColor(background) == Brightness.light ? const Color(0xFF410002) : Colors.white;

/// A "LIVE now" card for the first screen: shows while a stream is on the air and opens the Live tab.
class LiveBanner extends ConsumerWidget {
  const LiveBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final live = ref.watch(liveStreamsProvider).value ?? const <LiveStreamModel>[];
    if (live.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final background = theme.colorScheme.errorContainer;
    final foreground = liveBannerForeground(background);
    final languages = [
      for (final s in live)
        if (s.language.isNotEmpty) liveLanguageName(s.language),
    ];
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(12.sp),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.sp),
          onTap: () => context.go('/live'),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
            child: Row(
              children: [
                Icon(Icons.sensors, color: foreground),
                SizedBox(width: 12.sp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "live_now".i18n(),
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: foreground),
                      ),
                      Text(
                        languages.isEmpty ? live.first.title : languages.join(' · '),
                        style: theme.textTheme.bodySmall?.copyWith(color: foreground),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: foreground),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
