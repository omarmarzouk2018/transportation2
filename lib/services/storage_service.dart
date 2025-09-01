import 'package:hive/hive.dart';
import '../models/route_model.dart';
import '../config/app_config.dart';

class StorageService {
  StorageService._internal();
  static final StorageService instance = StorageService._internal();

  late Box _favoritesBox;
  late Box _settingsBox;

  Future<void> init() async {
    _favoritesBox = Hive.box(AppConfig.hiveBoxName);
    _settingsBox = Hive.box('settings_box');
  }

  Future<void> saveFavoriteRoute(RouteModel route) async {
    await _favoritesBox.put(route.id, route.toJson());
  }

  Future<List<RouteModel>> getFavoriteRoutes() async {
    final list = <RouteModel>[];
    for (final v in _favoritesBox.values) {
      if (v is Map) {
        list.add(RouteModel.fromJson(Map<String, dynamic>.from(v)));
      } else if (v is String) {
        try {
          list.add(RouteModel.fromJson(Map<String, dynamic>.from(v as dynamic)));
        } catch (_) {}
      }
    }
    return list;
  }

  Future<void> deleteFavoriteRoute(String id) async {
    await _favoritesBox.delete(id);
  }

  dynamic getSetting(String key) => _settingsBox.get(key);

  Future<void> setSetting(String key, dynamic value) async =>
      await _settingsBox.put(key, value);

  Future<void> migrateFromSqlite() async {
    // Placeholder: describe migration approach in docs.
  }
}
