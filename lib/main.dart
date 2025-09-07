// import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'db/hive_adapters.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/app_config.dart';
import 'app.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // تهيئة الـ backend
  await FMTCObjectBoxBackend().initialise();
  // Ensure the store "mapStore" exists
  await FMTCStore('mapStore').manage.create();
  // Load environment from Platform.environment if present. Fallbacks are in AppConfig.
  try {
    await dotenv.load(fileName: ".env");
    AppConfig.loadFromEnv(dotenv.env);
  } catch (_) {
    // Non-critical on platforms without full env
  }
  runApp(const App());
}

  // await Hive.initFlutter();
  // registerAdapters();
  // await Hive.openBox(AppConfig.hiveBoxName);
  // await Hive.openBox('settings_box');
  // await Hive.openBox('traffic_samples');

//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//       .then((_) {
//     runApp(const App());
//   });
