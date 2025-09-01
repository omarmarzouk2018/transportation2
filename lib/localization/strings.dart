import 'dart:convert';
import 'package:flutter/services.dart';

class Strings {
  static Map<String, Map<String, String>> _translations = {
    'start_stop_tracking': {'ar': 'تشغيل/إيقاف تتبع الموقع', 'en': 'Start/Stop Tracking'},
    'go_to_destination': {'ar': 'اذهب إلى هذا المكان', 'en': 'Go To Destination'},
    'night_mode': {'ar': 'وضع ليلي', 'en': 'Night Mode'},
  };

  static Future<void> loadFromAssets() async {
    try {
      final data = await rootBundle.loadString('assets/translations.json');
      final map = jsonDecode(data) as Map<String, dynamic>;
      _translations.clear();
      map.forEach((k, v) {
        _translations[k] = (v as Map).map((kk, vv) => MapEntry(kk as String, vv as String));
      });
    } catch (_) {}
  }

  static String t(String key, String locale) {
    final map = _translations[key];
    if (map == null) return key;
    return map[locale] ?? map['en'] ?? key;
  }
}
