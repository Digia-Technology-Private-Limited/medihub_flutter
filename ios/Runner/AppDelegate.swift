import Flutter
import UIKit
import clevertap_plugin
import CleverTapSDK

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    CleverTapPluginCustomTemplates.registerCustomTemplates("digia_templates", nil)
    GeneratedPluginRegistrant.register(with: self)
    CleverTap.autoIntegrate()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

