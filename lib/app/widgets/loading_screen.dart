import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/providers/router_provider.dart';

import 'loading_screen_controller.dart';

class LoadingScreen {
  LoadingScreen._shareInstance();

  static final LoadingScreen _shared = LoadingScreen._shareInstance();

  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  // NEW: Counter to track how many active requests require the loader to be visible.
  int _showCount = 0;

  void show({required BuildContext context, String text = "base_loading"}) {
    // 1. Increment the counter immediately.
    _showCount++;

    // 2. If the counter goes from 0 to 1, we show the overlay.
    // Otherwise, we just update the text on the existing overlay.
    if (_controller == null) {
      // Use the private method to show the overlay
      final rootCtx = navigatorKey.currentContext;
      if (rootCtx == null || !rootCtx.mounted) {
        debugPrint("Warning: Cannot show loading overlay — root context not available");
        return;
      }
      _controller = _showOverlay(
        context: rootCtx, // <-- pass root context
        text: text.i18n(), // <-- pass the KEY, not the translated string
      );
      // });
    } else {
      // Overlay is already visible, just update the text.
      _controller?.update(text.i18n());
    }
  }

  void hide() {
    // 1. Decrement the counter, preventing it from dropping below zero.
    _showCount = (_showCount - 1).clamp(0, _showCount);

    // 2. Only close the overlay if the last reference is gone.
    if (_showCount == 0) {
      _controller?.close();
      _controller = null;
    }
    // If _showCount > 0, another caller is still active, so the overlay remains visible.
  }

  // Renamed to _showOverlay for better encapsulation
  LoadingScreenController? _showOverlay({required BuildContext context, required String text}) {
    final textController = StreamController<String>();
    textController.add(text);
    final state = navigatorKey.currentState?.overlay; //Overlay.of(context);
    if (state == null) {
      return null;
    }

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 200.sp, minWidth: 200.sp),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     SizedBox(height: 10.sp),
                    const CircularProgressIndicator(),
                     SizedBox(height: 10.sp),
                    StreamBuilder(
                      stream: textController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.requireData,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        textController.close();
        overlay.remove();
        return true;
      },
      update: (String text) {
        textController.add(text);
        return true;
      },
    );
  }
}
