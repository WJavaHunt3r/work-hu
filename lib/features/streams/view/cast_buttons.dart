import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chrome_cast/flutter_chrome_cast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/streams/cast/live_cast.dart';

/// The Cast button on the live picture: opens [showCastSheet]; filled while casting.
class CastButton extends StatelessWidget {
  const CastButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LiveCastDevice?>(
      valueListenable: LiveCast.instance.device,
      builder: (context, device, _) => IconButton(
        tooltip: "live_cast".i18n(),
        color: Colors.white,
        icon: Icon(device == null ? Icons.cast : Icons.cast_connected),
        onPressed: () => showCastSheet(context),
      ),
    );
  }
}

/// iOS only: Apple's AirPlay button (`AVRoutePickerView`, the platform view `dukapp/airplay` registered in
/// AppDelegate.swift). Picking an Apple TV makes `video_player` hand the stream to it; the app's picture stays black.
class AirPlayButton extends StatelessWidget {
  const AirPlayButton({super.key});

  static bool get supported => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "live_airplay".i18n(),
      child: SizedBox(
        width: 40.sp,
        height: 40.sp,
        child: const UiKitView(viewType: 'dukapp/airplay', creationParamsCodec: StandardMessageCodec()),
      ),
    );
  }
}

/// The Cast devices on the network to pick from, or the connected one with a button to stop.
Future<void> showCastSheet(BuildContext context) async {
  final cast = LiveCast.instance;
  cast.startDiscovery();
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: ValueListenableBuilder<LiveCastDevice?>(
        valueListenable: cast.device,
        builder: (context, device, _) {
          if (device != null) {
            return Padding(
              padding: EdgeInsets.fromLTRB(16.sp, 0, 16.sp, 16.sp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(device.connected ? Icons.cast_connected : Icons.cast),
                    title: Text(device.name),
                    subtitle: Text((device.connected ? "live_cast_connected" : "live_cast_connecting").i18n()),
                  ),
                  SizedBox(height: 8.sp),
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.stop),
                    label: Text("live_cast_stop".i18n()),
                    onPressed: () {
                      cast.stop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }
          return StreamBuilder<List<GoogleCastDevice>>(
            stream: cast.devices,
            initialData: cast.devicesNow,
            builder: (context, snapshot) {
              final devices = snapshot.data ?? const <GoogleCastDevice>[];
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp),
                    child: Text("live_cast_title".i18n(), style: Theme.of(context).textTheme.titleMedium),
                  ),
                  for (final d in devices)
                    ListTile(
                      leading: const Icon(Icons.tv),
                      title: Text(d.friendlyName),
                      subtitle: d.modelName == null ? null : Text(d.modelName!),
                      onTap: () => cast.connect(d),
                    ),
                  if (devices.isEmpty)
                    ListTile(
                      leading: const SizedBox.square(dimension: 24, child: CircularProgressIndicator.adaptive()),
                      title: Text("live_cast_searching".i18n()),
                    ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.sp, 8.sp, 16.sp, 16.sp),
                    child: Text("live_cast_hint".i18n(), style: Theme.of(context).textTheme.bodySmall),
                  ),
                ],
              );
            },
          );
        },
      ),
    ),
  );
  cast.stopDiscovery();
}
