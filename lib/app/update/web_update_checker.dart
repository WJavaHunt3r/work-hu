import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';

import 'page_reload_stub.dart' if (dart.library.js_interop) 'page_reload_web.dart';

/// On web, detects a newly deployed build while the app stays open (e.g. an installed PWA that is
/// only resumed, never reloaded) and offers a reload. Does nothing on native platforms.
///
/// A deploy is detected by a change of the `main.dart.js` ETag, so the pubspec version doesn't need
/// to be bumped for every deploy.
class WebUpdateChecker extends StatefulWidget {
  final Widget child;

  const WebUpdateChecker({super.key, required this.child});

  @override
  State<WebUpdateChecker> createState() => _WebUpdateCheckerState();
}

class _WebUpdateCheckerState extends State<WebUpdateChecker> with WidgetsBindingObserver {
  static const _checkInterval = Duration(minutes: 5);

  final Dio _dio = Dio();
  Timer? _timer;
  String? _loadedBuild;
  bool _updateAvailable = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    WidgetsBinding.instance.addObserver(this);
    _fetchBuildId().then((id) => _loadedBuild = id);
    _timer = Timer.periodic(_checkInterval, (_) => _check());
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  Future<String?> _fetchBuildId() async {
    try {
      final res = await _dio.head(
        '${Uri.base.origin}/main.dart.js',
        queryParameters: {'t': DateTime.now().millisecondsSinceEpoch},
        options: Options(headers: {'Cache-Control': 'no-cache'}),
      );
      return res.headers.value('etag') ?? res.headers.value('last-modified');
    } catch (_) {
      return null;
    }
  }

  Future<void> _check() async {
    if (_updateAvailable) return;
    final current = await _fetchBuildId();
    if (current == null) return;
    if (_loadedBuild == null) {
      _loadedBuild = current;
      return;
    }
    if (current != _loadedBuild && mounted) {
      setState(() => _updateAvailable = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Always keep the Stack so showing the banner doesn't reparent (and reset) the app below it.
    return Stack(
      children: [
        widget.child,
        if (_updateAvailable)
          Positioned(
            left: 12.sp,
            right: 12.sp,
            bottom: 90.sp,
            child: SafeArea(
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12.sp),
                color: colorScheme.inverseSurface,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.sp, right: 4.sp, top: 4.sp, bottom: 4.sp),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('update_available'.i18n(), style: TextStyle(color: colorScheme.onInverseSurface)),
                      ),
                      TextButton(
                        onPressed: reloadPage,
                        child: Text('update_reload'.i18n(), style: TextStyle(color: colorScheme.inversePrimary)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
