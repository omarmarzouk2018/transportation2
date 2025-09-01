import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_config.dart';
import 'providers/tracking_provider.dart';
import 'providers/route_provider.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/settings_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  Future<List> _loadInitialFavorites() async {
    await StorageService.instance.init();
    return await StorageService.instance.getFavoriteRoutes();
  }

  @override
  Widget build(BuildContext context) {
    // final locale = const Locale('ar'); // default Arabic
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TrackingProvider()),
        ChangeNotifierProvider(create: (_) => RouteProvider()),
        FutureProvider<List?>(
          create: (_) => _loadInitialFavorites(),
          initialData: const [],
        ),
      ],
      child: MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'AlexTransportation',
  locale: const Locale('ar'),
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('ar'),
    Locale('en'),
  ],
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  themeMode: AppConfig.defaultNightMode ? ThemeMode.dark : ThemeMode.light,
  initialRoute: '/',
  routes: {
    '/': (_) => const HomeScreen(),
    '/favorites': (_) => const FavoritesScreen(),
    '/settings': (_) => const SettingsScreen(),
  },
),
    );
  }
}
