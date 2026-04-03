import Flutter
import UIKit
import WebEngage
import webengage_flutter
import digia_engage_webengage
import UserNotifications


@main
@objc class AppDelegate: FlutterAppDelegate {

var bridge:WebEngagePlugin? = nil

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
  ) -> Bool {
  GeneratedPluginRegistrant.register(with: self)
           UNUserNotificationCenter.current().delegate = self
    application.registerForRemoteNotifications()
        // Basic set up
        bridge = WebEngagePlugin()
          // Push notification delegates
        WebEngage.sharedInstance().pushNotificationDelegate = self.bridge
        WebEngage.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions, notificationDelegate: DigiaSuppressPlugin.shared())
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

