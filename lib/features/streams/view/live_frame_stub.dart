import 'package:flutter/widgets.dart';

/// Cloudflare's embedded player page; only exists in the web build (the apps play the HLS stream themselves).
Widget buildLiveFrame(String url) => const SizedBox.shrink();
