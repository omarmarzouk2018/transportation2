import 'package:flutter/foundation.dart';

class AppConfig {
  static String orsApiKey = '';
  static String osrmBaseUrl = 'https://router.project-osrm.org';
  static String hiveBoxName = 'favorites_box';
  static String notificationIcon = 'app_icon';
  static bool defaultNightMode = false;

  static const Map<String, double> defaultSpeedThresholds = {
    'stationary': 0.5,
    'walking': 2.0,
    'driving': 6.0,
  };

  static void loadFromEnv(Map<String, String> env) {
    orsApiKey = env['ORS_API_KEY'] ?? orsApiKey;
    osrmBaseUrl = env['OSRM_BASE_URL'] ?? osrmBaseUrl;
    hiveBoxName = env['HIVE_BOX_NAME'] ?? hiveBoxName;
    notificationIcon = env['NOTIFICATION_ICON'] ?? notificationIcon;
    defaultNightMode = (env['DEFAULT_NIGHT_MODE']?.toLowerCase() == 'true');
    
    if (kDebugMode) {
      print("AppConfig loaded: ORS key set = ${orsApiKey.isNotEmpty}");
    }
  }
}
