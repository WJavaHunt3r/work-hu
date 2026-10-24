import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

final _registered = <String>{};

/// Cloudflare's embedded player page. Browsers other than Safari can't play HLS themselves, and the embedded player
/// handles that and the encoder's reconnects on its own.
Widget buildLiveFrame(String url) {
  final viewType = 'dukapp-live-${url.hashCode}';
  if (_registered.add(viewType)) {
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final frame = web.HTMLIFrameElement()
        ..src = '$url?autoplay=true&preload=auto'
        ..allow = 'autoplay; fullscreen; picture-in-picture; encrypted-media'
        ..allowFullscreen = true;
      frame.style
        ..border = '0'
        ..width = '100%'
        ..height = '100%';
      return frame;
    });
  }
  return HtmlElementView(viewType: viewType);
}
