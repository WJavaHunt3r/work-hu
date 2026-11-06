import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_chrome_cast/flutter_chrome_cast.dart';
import 'package:work_hu/features/streams/data/model/live_stream_model.dart';

/// A Cast device the app is connecting or connected to.
typedef LiveCastDevice = ({String name, bool connected});

/// Plays the live broadcast on a TV: Chromecast and Google TV through the Google Cast SDK (`flutter_chrome_cast`) in
/// the iOS and Android apps. The TV runs Google's Default Media Receiver, which fetches the HLS address itself, so the
/// phone only says what to play and may be locked or leave the Live page meanwhile (Cloudflare sends CORS headers, which
/// the receiver needs). AirPlay is not here: on iOS `video_player` hands its own picture to an Apple TV ([AirPlayButton]).
///
/// The receiver does not reconnect when the encoder drops, so while the app runs a watchdog loads the address again
/// whenever the receiver stops playing, for at most [_giveUpAfter] without playing (the Live page keeps a stream that
/// dropped out of the list for 3 minutes too). One instance for the app, because the session outlives the Live page.
class LiveCast {
  LiveCast._();

  static final instance = LiveCast._();

  @visibleForTesting
  static bool? supportedOverride;

  static bool get supported =>
      supportedOverride ??
      (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS));

  static const _tick = Duration(seconds: 5);
  static const _loadGrace = Duration(seconds: 20);
  static const _giveUpAfter = Duration(minutes: 3);

  /// The device of the current session, null without one.
  final device = ValueNotifier<LiveCastDevice?>(null);

  bool get casting => device.value?.connected == true;

  bool _initialized = false;
  LiveStreamModel? _wanted;
  bool _paused = false;
  DateTime _loadedAt = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastPlaying = DateTime.now();
  Timer? _watchdog;

  /// Sets up the Cast SDK, the first time the Live page shows a player (on iOS this asks for the local network then, not
  /// at the app's start).
  void ensureInitialized() {
    if (_initialized || !supported) return;
    _initialized = true;
    const appId = GoogleCastDiscoveryCriteria.kDefaultApplicationId;
    final options = defaultTargetPlatform == TargetPlatform.iOS
        ? IOSGoogleCastOptions(GoogleCastDiscoveryCriteriaInitialize.initWithApplicationID(appId))
        : GoogleCastOptionsAndroid(appId: appId);
    GoogleCastContext.instance.setSharedInstanceWithOptions(options);
    GoogleCastSessionManager.instance.currentSessionStream.listen(_sessionChanged);
  }

  void _sessionChanged(GoogleCastSession? session) {
    final name = session?.device?.friendlyName ?? '';
    final wasCasting = casting;
    device.value = switch (session?.connectionState) {
      GoogleCastConnectState.connected => (name: name, connected: true),
      GoogleCastConnectState.connecting => (name: name, connected: false),
      _ => null,
    };
    if (casting && !wasCasting) {
      _paused = false;
      _lastPlaying = DateTime.now();
      // A session resumed with the broadcast already playing on the TV keeps it
      if (_wanted != null && _receiverUrl != _wanted!.hlsUrl) _load();
      _startWatchdog();
    } else if (!casting) {
      _watchdog?.cancel();
      _watchdog = null;
    }
  }

  /// The stream the Live page shows; plays it on the TV when casting (again only when it is another one).
  void show(LiveStreamModel stream) {
    if (!supported) return;
    final changed = _wanted?.hlsUrl != stream.hlsUrl;
    _wanted = stream;
    _lastPlaying = DateTime.now();
    if (casting && changed && _receiverUrl != stream.hlsUrl) _load();
    if (casting) _startWatchdog();
  }

  void pause() {
    _paused = true;
    GoogleCastRemoteMediaClient.instance.pause();
  }

  /// Back to the live edge: a paused live stream is far behind by now.
  void play() {
    _paused = false;
    _lastPlaying = DateTime.now();
    _load();
  }

  Future<void> connect(GoogleCastDevice target) => GoogleCastSessionManager.instance.startSessionWithDevice(target);

  Future<void> stop() => GoogleCastSessionManager.instance.endSessionAndStopCasting();

  /// Android only looks for devices while asked to (the picker is open); iOS looks by itself once initialized.
  void startDiscovery() => GoogleCastDiscoveryManager.instance.startDiscovery(activeScan: true);

  void stopDiscovery() {
    if (defaultTargetPlatform == TargetPlatform.android) GoogleCastDiscoveryManager.instance.stopDiscovery();
  }

  Stream<List<GoogleCastDevice>> get devices => GoogleCastDiscoveryManager.instance.devicesStream;

  List<GoogleCastDevice> get devicesNow => GoogleCastDiscoveryManager.instance.devices;

  String? get _receiverUrl {
    final info = GoogleCastRemoteMediaClient.instance.mediaStatus?.mediaInformation;
    return info?.contentUrl?.toString() ?? info?.contentId;
  }

  void _load() {
    final stream = _wanted;
    if (stream == null || !casting) return;
    _loadedAt = DateTime.now();
    GoogleCastRemoteMediaClient.instance
        .loadMedia(
          GoogleCastMediaInformation(
            contentId: stream.hlsUrl,
            contentUrl: Uri.parse(stream.hlsUrl),
            contentType: 'application/x-mpegURL',
            streamType: CastMediaStreamType.live,
            // Cloudflare's HLS segments are fragmented MP4 (init.mp4, seg_N.mp4); the receiver assumes MPEG-TS without
            // these and stays loading, the TV showing only the Cast logo. The plugin passes only the video one on iOS.
            hlsSegmentFormat: CastHlsSegmentFormat.fmp4,
            hlsVideoSegmentFormat: HlsVideoSegmentFormat.fmp4,
            metadata: GoogleCastGenericMediaMetadata(title: stream.title, subtitle: 'DukApp'),
          ),
        )
        // Not on the air (yet): the watchdog tries again
        .catchError((_) {});
  }

  void _startWatchdog() {
    _watchdog ??= Timer.periodic(_tick, (_) => _check());
  }

  void _check() {
    if (!casting || _wanted == null || _paused) return;
    final state = GoogleCastRemoteMediaClient.instance.mediaStatus?.playerState;
    if (state == CastMediaPlayerState.playing) {
      _lastPlaying = DateTime.now();
      return;
    }
    final now = DateTime.now();
    if (now.difference(_lastPlaying) > _giveUpAfter) return;
    // Loading and a short buffering get time; a receiver that stopped (idle: ended, failed) or keeps buffering after the
    // encoder dropped gets the address again
    if (now.difference(_loadedAt) > _loadGrace && now.difference(_lastPlaying) > _loadGrace) _load();
  }
}
