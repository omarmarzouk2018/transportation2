import 'package:flutter/foundation.dart';

class AppConfig {
  static String orsApiKey = '';
  static String osrmBaseUrl = 'https://router.project-osrm.org';
  static String hiveBoxName = 'favorites_box';
  static String notificationIcon = 'app_icon';
  static bool defaultNightMode = false;

  static Map<String, double> defaultSpeedThresholds = const {
    'stationary': 0.5,
    'walking': 2.0,
    'driving': 6.0,
  };

  static void loadFromEnv(Map<String, String> env) {
    if (env.containsKey('ORS_API_KEY')) {
      orsApiKey = env['ORS_API_KEY'] ?? '';
    }
    if (env.containsKey('OSRM_BASE_URL')) {
      osrmBaseUrl = env['OSRM_BASE_URL'] ?? osrmBaseUrl;
    }
    if (env.containsKey('HIVE_BOX_NAME')) {
      hiveBoxName = env['HIVE_BOX_NAME'] ?? hiveBoxName;
    }
    if (env.containsKey('NOTIFICATION_ICON')) {
      notificationIcon = env['NOTIFICATION_ICON'] ?? notificationIcon;
    }
    // debug print
    if (kDebugMode) {
      // ignore: avoid_print
      print('AppConfig loaded: ORS key set: ${orsApiKey.isNotEmpty}');
    }
  }
}
