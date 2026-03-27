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
    // Parse dart-defines injected via --dart-define-from-file=config/secrets.json
    let defines = parseDartDefines()
    let accountID = defines["CLEVERTAP_ACCOUNT_ID"] ?? ""
    let token = defines["CLEVERTAP_TOKEN"] ?? ""
    let region = defines["CLEVERTAP_REGION"] ?? ""

    // Set CleverTap credentials before autoIntegrate so the SDK picks them up
    CleverTap.setCredentialsWithAccountID(accountID, token: token, region: region)
    GeneratedPluginRegistrant.register(with: self)
    CleverTap.autoIntegrate()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Decodes DART_DEFINES from Info.plist (set via $(DART_DEFINES) build variable).
  // Each entry is a base64-encoded "KEY=VALUE" string, comma-separated.
  private func parseDartDefines() -> [String: String] {
    guard let raw = Bundle.main.infoDictionary?["DART_DEFINES"] as? String, !raw.isEmpty else {
      return [:]
    }
    var result = [String: String]()
    raw.components(separatedBy: ",").forEach { encoded in
      guard let data = Data(base64Encoded: encoded),
            let decoded = String(data: data, encoding: .utf8) else { return }
      let idx = decoded.firstIndex(of: "=") ?? decoded.endIndex
      let key = String(decoded[..<idx])
      let value = idx < decoded.endIndex ? String(decoded[decoded.index(after: idx)...]) : ""
      if !key.isEmpty { result[key] = value }
    }
    return result
  }
}

