import 'package:digia_clevertap/digia_clevertap.dart';
import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/material.dart';
import 'package:medihub/core/services/analytics_service.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/address_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/products_provider.dart';
import 'providers/theme_provider.dart';
import 'views/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();
  await themeProvider.initialize();
  await AnalyticsService().initialize();
  AnalyticsService().trackAppOpened();

  await Digia.initialize(
    DigiaConfig(apiKey: '698b1b7979d23afa242dcc7d'),
  );
  Digia.register(CleverTapPlugin());

  runApp(MediHubApp(themeProvider: themeProvider));
}

class MediHubApp extends StatelessWidget {
  MediHubApp({super.key, required this.themeProvider});

  final ThemeProvider themeProvider;
  final DigiaNavigatorObserver _digiaNavigatorObserver =
      DigiaNavigatorObserver();

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
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'MediHub',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            navigatorObservers: [_digiaNavigatorObserver],
            builder: (context, child) => DigiaHost(
              child: child ?? const SizedBox.shrink(),
            ),
            home: const MainShell(),
          );
        },
      ),
    );
  }
}
