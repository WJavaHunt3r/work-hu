import AVKit
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    engineBridge.pluginRegistry.registrar(forPlugin: "AirPlayButton")?
      .register(AirPlayButtonFactory(), withId: "dukapp/airplay")
  }
}

/// The AirPlay button on the live picture (AirPlayButton in cast_buttons.dart): Apple's route picker. video_player
/// lets its player follow an AirPlay route, so the Apple TV then plays the stream itself.
class AirPlayButtonFactory: NSObject, FlutterPlatformViewFactory {
  func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
    return AirPlayButtonView(frame: frame)
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

class AirPlayButtonView: NSObject, FlutterPlatformView {
  private let picker: AVRoutePickerView

  init(frame: CGRect) {
    picker = AVRoutePickerView(frame: frame)
    picker.tintColor = .white
    picker.activeTintColor = .systemBlue
    picker.prioritizesVideoDevices = true
    picker.backgroundColor = .clear
    super.init()
  }

  func view() -> UIView {
    return picker
  }
}
