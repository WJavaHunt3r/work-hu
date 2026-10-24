import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web/web.dart' as web;

const _hlsScript = 'https://cdn.jsdelivr.net/npm/hls.js@1.5.17/dist/hls.min.js';
Future<void>? _scriptLoaded;

/// Loads hls.js once: browsers other than Safari can't play an HLS manifest themselves.
Future<void> _loadHlsJs() => _scriptLoaded ??= () {
  if (globalContext.has('Hls')) return Future<void>.value();
  final done = Completer<void>();
  final script = web.HTMLScriptElement()
    ..src = _hlsScript
    ..async = true;
  script.onload = ((web.Event _) => done.complete()).toJS;
  script.onerror = ((web.Event _) => done.completeError('hls.js could not be loaded')).toJS;
  web.document.head!.append(script);
  return done.future;
}();

/// The broadcast's sound only, in an audio element (no picture is downloaded for the page to show). Unlike the embedded
/// video page, an audio element keeps playing when the browser tab is in the background or the screen is locked, and
/// the media session gives the lock screen and notification its controls.
Widget buildLiveWebAudio({required String hlsUrl, required String title}) =>
    _LiveWebAudio(hlsUrl: hlsUrl, title: title);

class _LiveWebAudio extends StatefulWidget {
  const _LiveWebAudio({required this.hlsUrl, required this.title});

  final String hlsUrl;
  final String title;

  @override
  State<_LiveWebAudio> createState() => _LiveWebAudioState();
}

class _LiveWebAudioState extends State<_LiveWebAudio> {
  final web.HTMLAudioElement _audio = web.HTMLAudioElement();
  JSObject? _hls;
  bool _playing = false;
  bool _failed = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _audio
      ..onplaying = ((web.Event _) => _setPlaying(true)).toJS
      ..onpause = ((web.Event _) => _setPlaying(false)).toJS;
    _start();
  }

  void _setPlaying(bool value) {
    if (!_disposed && mounted) setState(() => _playing = value);
  }

  Future<void> _start() async {
    try {
      if (_audio.canPlayType('application/vnd.apple.mpegurl').isNotEmpty) {
        // Safari plays HLS itself
        _audio.src = widget.hlsUrl;
      } else {
        await _loadHlsJs();
        if (_disposed) return;
        final ctor = globalContext['Hls'] as JSFunction;
        final hls = ctor.callAsConstructor<JSObject>();
        hls.callMethod('loadSource'.toJS, widget.hlsUrl.toJS);
        hls.callMethod('attachMedia'.toJS, _audio);
        // A stream that was cut (the encoder reconnecting) is picked up again instead of staying silent
        final onError = ((JSAny? _, JSObject data) {
          if ((data['fatal'] as JSBoolean?)?.toDart ?? false) {
            final type = (data['type'] as JSString?)?.toDart;
            hls.callMethod((type == 'mediaError' ? 'recoverMediaError' : 'startLoad').toJS);
          }
        }).toJS;
        hls.callMethod('on'.toJS, 'hlsError'.toJS, onError);
        _hls = hls;
      }
      _setMediaSession();
      await _audio.play().toDart;
    } catch (_) {
      if (!_disposed && mounted) setState(() => _failed = _audio.paused && _hls == null);
    }
  }

  void _setMediaSession() {
    final session = web.window.navigator.mediaSession;
    session.metadata = web.MediaMetadata(web.MediaMetadataInit(title: widget.title, artist: 'DukApp'));
    session.setActionHandler('play', (() => _audio.play()).toJS);
    session.setActionHandler('pause', (() => _audio.pause()).toJS);
  }

  @override
  void didUpdateWidget(_LiveWebAudio old) {
    super.didUpdateWidget(old);
    if (old.hlsUrl != widget.hlsUrl) {
      _hls?.callMethod('loadSource'.toJS, widget.hlsUrl.toJS);
      if (_hls == null) _audio.src = widget.hlsUrl;
      _audio.play();
      _setMediaSession();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _audio.pause();
    _hls?.callMethod('destroy'.toJS);
    _audio.removeAttribute('src');
    final session = web.window.navigator.mediaSession;
    session.metadata = null;
    session.setActionHandler('play', null);
    session.setActionHandler('pause', null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 120.sp,
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12.sp)),
      child: Center(
        child: _failed
            ? const Icon(Icons.error_outline, color: Colors.white70, size: 48)
            : IconButton(
                iconSize: 64.sp,
                color: Colors.white,
                tooltip: widget.title,
                icon: Icon(
                  _playing ? Icons.pause_circle : Icons.play_circle,
                  color: theme.colorScheme.primaryContainer,
                ),
                onPressed: () => _playing ? _audio.pause() : _audio.play(),
              ),
      ),
    );
  }
}
