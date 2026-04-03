import 'package:digia_engage/digia_engage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:medihub/firebase_options.dart';
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
    await Digia.initialize(
      DigiaConfig(
        apiKey: 'YOUR_DIGIA_API_KEY', // TODO: Replace with actual API key
        flavor: Flavor.debug(environment: Environment.development),
        logLevel: kDebugMode ? DigiaLogLevel.verbose : DigiaLogLevel.error,
      ),
    );

    WebEngagePlugin _webEngagePlugin = new WebEngagePlugin();

    if (kDebugMode) {
      debugPrint('[DiagiaService] MoEngage initialised');
    }
    Digia.register(digia.WebEngagePlugin());

    WebEngagePlugin.setUserEmail("ram@gmail.com");
    WebEngagePlugin.userLogin('ios');
  }
}
