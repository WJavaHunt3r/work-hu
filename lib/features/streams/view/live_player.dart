import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
///
/// The picture's fullscreen button opens [LiveFullscreenPage]: landscape, without the system bars, showing whichever
/// connection the watchdog has open ([_videoNow]), and closed again when this player goes away.
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

  /// The video connection for the fullscreen page; it changes whenever the watchdog reconnects.
  final _videoNow = ValueNotifier<VideoPlayerController?>(null);
  Route<void>? _fullscreen;
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
    final fullscreen = _fullscreen;
    if (fullscreen != null && fullscreen.isActive) fullscreen.navigator?.removeRoute(fullscreen);
    _release();
    _videoNow.dispose();
    super.dispose();
  }

  Future<void> _openFullscreen() async {
    final route = MaterialPageRoute<void>(builder: (context) => LiveFullscreenPage(video: _videoNow));
    _fullscreen = route;
    await Navigator.of(context, rootNavigator: true).push(route);
    _fullscreen = null;
  }

  void _release() {
    final video = _video;
    final audio = _audio;
    _video = null;
    _audio = null;
    _videoNow.value = null;
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
      if (generation == _generation && mounted) {
        _videoNow.value = _video;
        setState(() => _connecting = false);
      }
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
                  if (showVideo)
                    Positioned(
                      right: 4.sp,
                      bottom: 4.sp,
                      child: IconButton(
                        tooltip: "live_fullscreen".i18n(),
                        color: Colors.white,
                        icon: const Icon(Icons.fullscreen),
                        onPressed: _openFullscreen,
                      ),
                    ),
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

/// The live picture on the whole screen: landscape, without the status and navigation bars. Shows the player's current
/// connection ([video]), so a reconnect while fullscreen goes on seamlessly. The rest of the app is portrait only
/// (main.dart), so leaving puts portrait and the bars back.
class LiveFullscreenPage extends StatefulWidget {
  const LiveFullscreenPage({super.key, required this.video});

  final ValueListenable<VideoPlayerController?> video;

  @override
  State<LiveFullscreenPage> createState() => _LiveFullscreenPageState();
}

class _LiveFullscreenPageState extends State<LiveFullscreenPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: ValueListenableBuilder<VideoPlayerController?>(
              valueListenable: widget.video,
              builder: (context, video, _) => video != null && video.value.isInitialized
                  ? AspectRatio(aspectRatio: video.value.aspectRatio, child: VideoPlayer(video))
                  : const CircularProgressIndicator(color: Colors.white),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                tooltip: "live_fullscreen_exit".i18n(),
                color: Colors.white,
                icon: const Icon(Icons.fullscreen_exit),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
