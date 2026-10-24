import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:localization/localization.dart';
import 'package:video_player/video_player.dart';
import 'package:work_hu/features/streams/data/model/live_stream_model.dart';

/// Plays a live stream in the iOS and Android apps: the picture with [VideoPlayer], or only the sound with just_audio
/// (which keeps playing with the screen off and shows lock-screen controls).
///
/// The stream address belongs to the live input, so it survives the encoder dropping and reconnecting; what does not
/// survive is the player's current connection. So a watchdog looks every few seconds, and when the picture or sound
/// has stopped moving (or the player reports an error) it opens the same address again until it plays.
class LivePlayer extends StatefulWidget {
  const LivePlayer({super.key, required this.stream, required this.audioOnly});

  final LiveStreamModel stream;
  final bool audioOnly;

  @override
  State<LivePlayer> createState() => _LivePlayerState();
}

class _LivePlayerState extends State<LivePlayer> {
  static const _tick = Duration(seconds: 4);
  static const _stuckTicksBeforeRestart = 3;

  VideoPlayerController? _video;
  AudioPlayer? _audio;
  Timer? _watchdog;
  bool _wantPlaying = true;
  bool _connecting = true;
  int _generation = 0;
  bool _opening = false;
  DateTime _openStarted = DateTime.now();
  Duration _lastPosition = Duration.zero;
  int _stuckTicks = 0;

  @override
  void initState() {
    super.initState();
    _watchdog = Timer.periodic(_tick, (_) => _check());
    _open();
  }

  @override
  void didUpdateWidget(LivePlayer old) {
    super.didUpdateWidget(old);
    if (old.stream.hlsUrl != widget.stream.hlsUrl || old.audioOnly != widget.audioOnly) {
      _wantPlaying = true;
      _open();
    }
  }

  @override
  void dispose() {
    _watchdog?.cancel();
    _generation++;
    _release();
    super.dispose();
  }

  void _release() {
    final video = _video;
    final audio = _audio;
    _video = null;
    _audio = null;
    video?.dispose();
    audio?.dispose();
  }

  /// (Re)opens the stream. A newer call makes an older one that is still connecting give up.
  Future<void> _open() async {
    final generation = ++_generation;
    _release();
    _stuckTicks = 0;
    _lastPosition = Duration.zero;
    _opening = true;
    _openStarted = DateTime.now();
    if (mounted) setState(() => _connecting = true);
    try {
      if (widget.audioOnly) {
        final audio = AudioPlayer();
        _audio = audio;
        await audio.setAudioSource(
          AudioSource.uri(
            Uri.parse(widget.stream.hlsUrl),
            tag: MediaItem(id: widget.stream.uid, title: widget.stream.title, album: 'DukApp'),
          ),
        );
        if (generation != _generation) return;
        if (_wantPlaying) unawaited(audio.play());
      } else {
        final video = VideoPlayerController.networkUrl(Uri.parse(widget.stream.hlsUrl));
        _video = video;
        await video.initialize();
        if (generation != _generation) return;
        if (_wantPlaying) await video.play();
      }
      if (generation == _generation && mounted) setState(() => _connecting = false);
    } catch (_) {
      // Not available (yet): the watchdog tries again on its next tick
      if (generation == _generation && mounted) setState(() => _connecting = true);
    } finally {
      if (generation == _generation) _opening = false;
    }
  }

  void _check() {
    if (!mounted || !_wantPlaying) return;
    // A slow connection attempt gets time to finish before it is abandoned
    if (_opening && DateTime.now().difference(_openStarted) < const Duration(seconds: 20)) return;
    final video = _video;
    final audio = _audio;
    final failed = video?.value.hasError == true || (video == null && audio == null) || _connecting;
    if (failed) {
      _open();
      return;
    }
    final position = audio?.position ?? video?.value.position ?? Duration.zero;
    if (position == _lastPosition) {
      _stuckTicks++;
    } else {
      _stuckTicks = 0;
      _lastPosition = position;
    }
    if (_stuckTicks >= _stuckTicksBeforeRestart) _open();
  }

  void _togglePlay() {
    setState(() => _wantPlaying = !_wantPlaying);
    if (_wantPlaying) {
      // A stopped live stream is far behind by now: reconnect to the live edge
      _open();
    } else {
      _video?.pause();
      _audio?.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final video = _video;
    final showVideo = !widget.audioOnly && video != null && video.value.isInitialized && !_connecting;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.sp),
          child: ColoredBox(
            color: Colors.black,
            child: AspectRatio(
              aspectRatio: showVideo ? video.value.aspectRatio : 16 / 9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (showVideo) VideoPlayer(video),
                  if (widget.audioOnly && !_connecting) Icon(Icons.headphones, size: 64.sp, color: Colors.white70),
                  if (_connecting && _wantPlaying)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 12.sp),
                        Text("live_connecting".i18n(), style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  if (!_wantPlaying) Icon(Icons.pause_circle_outline, size: 64.sp, color: Colors.white70),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 8.sp),
        IconButton.filledTonal(
          iconSize: 32.sp,
          tooltip: (_wantPlaying ? "live_pause" : "live_play").i18n(),
          color: theme.colorScheme.primary,
          icon: Icon(_wantPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _togglePlay,
        ),
      ],
    );
  }
}
