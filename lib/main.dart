import 'package:flutter/material.dart';
import 'package:medihub/core/services/analytics_service.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/products_provider.dart';

import 'providers/address_provider.dart';
import 'views/main_shell.dart';
import 'package:digiaclevertap/digia_clevertap_widget.dart';
import 'package:digia_ui/digia_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();
  await themeProvider.initialize();
  await AnalyticsService().initialize();
  final digiaUI = await DigiaUI.initialize(
    DigiaUIOptions(
      accessKey: '697b13250753c105e4cb83a7',
      flavor: Flavor.debug(),
    ),
  );

  runApp(
    DigiaUIApp(
      digiaUI: digiaUI,
      builder: (context) => MediHubApp(themeProvider: themeProvider),
    ),
  );
}

class MediHubApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const MediHubApp({super.key, required this.themeProvider});

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
            home: DigiaClevertapWidget(child: const MainShell()),
          );
        },
      ),
    );
  }
}
