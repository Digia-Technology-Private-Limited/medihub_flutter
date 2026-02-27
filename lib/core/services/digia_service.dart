import 'package:digia_moengage_plugin/digia_moengage_plugin.dart';
import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:moengage_flutter/moengage_flutter.dart';

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

  // Keep a reference so it stays alive for the app lifetime.
  MoEngageFlutter? _moEngage;

  static MoEngageFlutter? get moEngage => _instance._moEngage;

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

    // ── 1. MoEngage ───────────────────────────────────────────────────────────
    _moEngage = MoEngageFlutter(
      // TODO: Replace with your real MoEngage App ID from the MoEngage dashboard.
      '11WPK0Z2N6HXU5R5DN5HUHYW',
      moEInitConfig: MoEInitConfig.defaultConfig(),
    );
    _moEngage!.initialise();

    if (kDebugMode) {
      debugPrint('[DiagiaService] MoEngage initialised');
    }

    // ── 2. Digia core ─────────────────────────────────────────────────────────
    // DigiaConfig.toOptions() maps to DigiaUIOptions and kicks off:
    //   • PreferencesStore init
    //   • NetworkClient construction
    //   • DSL config fetch (remote or local asset, controlled by Flavor)
    //   • DigiaUIManager registration
    await Digia.initialize(
      DigiaConfig(
        // TODO: Replace with your real Digia API key from the Digia dashboard.
        apiKey: '698b1b7979d23afa242dcc7d',

        // Flavor.debug fetches the DSL config from Digia servers on every
        // launch — ideal during development. Switch to Flavor.release for
        // production builds to load from a bundled local asset.
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
    Digia.register(MoEngagePlugin(instance: _moEngage!));

    if (kDebugMode) {
      debugPrint('[DiagiaService] MoEngagePlugin registered with Digia');
    }
  }
}
