import 'package:digia_engage/digia_engage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:digia_engage_webengage/digia_engage_webengage.dart' as digia;

/// Bootstraps the Digia SDK and wires it to MoEngage as the CEP provider.
///
/// Call [DigiaService.initialize] once in [main] before [runApp].
/// The service is a singleton — repeated calls are no-ops.
///
/// ```dart
/// await DigiaService.initialize();
/// ```
class DigiaService {
  static final DigiaService _instance = DigiaService._();
  factory DigiaService() => _instance;
  DigiaService._();

  bool _initialized = false;

  /// Initializes the Digia SDK and registers MoEngage as the CEP plugin.
  ///
  /// Steps performed:
  /// 1. Create and initialise the [MoEngageFlutter] instance.
  /// 2. Call [Digia.initialize] — this boots the full src stack:
  ///    SharedPreferences, NetworkClient, DSL config loading via [DigiaUI.initialize],
  ///    and [DigiaUIManager].
  /// 3. Register [MoEngagePlugin] so MoEngage self-handled in-app campaigns
  ///    are routed into Digia's rendering engine.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    WebEngagePlugin _webEngagePlugin = new WebEngagePlugin();
    await getFCMTokenAndPassToWebEngage();

    if (kDebugMode) {
      debugPrint('[DiagiaService] MoEngage initialised');
    }

    WebEngagePlugin.setUserEmail("ramsthr@gmail.com");
    WebEngagePlugin.userLogin('android');

    await Digia.initialize(
      DigiaConfig(
        apiKey: 'YOUR_DIGIA_API_KEY',
        flavor: Flavor.debug(environment: Environment.development),
        logLevel: kDebugMode ? DigiaLogLevel.verbose : DigiaLogLevel.error,
      ),
    );

    if (kDebugMode) {
      debugPrint('[DiagiaService] Digia SDK initialised');
    }

    // ── 3. Register MoEngage as the CEP plugin ───────────────────────────────
    // From this point, MoEngage self-handled in-app campaigns are translated
    // into InAppPayload objects and handed to DigiaHost for rendering.
    Digia.register(digia.WebEngagePlugin());

    if (kDebugMode) {
      debugPrint('[DiagiaService] MoEngagePlugin registered with Digia');
    }
  }
}

Future<void> getFCMTokenAndPassToWebEngage() async {
  try {
    await Firebase.initializeApp();

    // Get the FCM token
    String? token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      print("FCM Token: $token");
      // Pass the token to WebEngage
      WebEngagePlugin.setPushToken(token);
    }

    // Listen for token refreshes and update WebEngage
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("FCM Token Refreshed: $newToken");
      WebEngagePlugin.setPushToken(newToken);
    });
  } catch (e) {
    print("Error getting FCM token: $e");
  }
}
