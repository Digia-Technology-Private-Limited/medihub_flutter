import 'package:flutter/material.dart';
import 'package:digia_ui/digia_ui.dart';
import 'package:medihub/core/services/analytics_service.dart';
import 'package:medihub/core/services/digia_service.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/products_provider.dart';

import 'providers/address_provider.dart';
import 'views/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();
  await themeProvider.initialize();
  await AnalyticsService().initialize();

  // Initialise Digia SDK (boots DigiaUI services) and register MoEngage.
  await DigiaService().initialize();

  runApp(MediHubApp(themeProvider: themeProvider));
}

class MediHubApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const MediHubApp({super.key, required this.themeProvider});

  // Shared navigator key — gives DigiaNavigatorObserver access to the
  // Navigator so screen names are forwarded to the MoEngage CEP plugin.
  // Now using DigiaHost.navigatorKey for consistency.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => CartProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (ctx, themeProvider, child) {
          return MaterialApp(
            title: 'MediHub',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

            // DigiaNavigatorObserver automatically forwards every route push/replace
            // to Digia.setCurrentScreen(), which the MoEngagePlugin translates
            // into MoEngage.setCurrentContext() for campaign targeting.
            // navigatorKey: DigiaHost.navigatorKey,
            navigatorObservers: [DigiaNavigatorObserver()],

            // DigiaHost wraps the entire widget tree so Digia can render
            // MoEngage self-handled in-app overlays above all app content.
            builder: (inx, child) => DigiaHost(
              child: child!,
            ),

            home: const MainShell(),
          );
        },
      ),
    );
  }
}
