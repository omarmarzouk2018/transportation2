class Constants {
  static const double STATIONARY_THRESHOLD = 0.5; // m/s
  static const double WALKING_THRESHOLD = 2.0; // m/s
  static const double DRIVING_THRESHOLD = 6.0; // m/s

  static const double ARRIVAL_ALERT_DISTANCE = 150.0; // meters

  static const String OSM_TILE_URL =
      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String NIGHT_TILE_URL =
      'https://tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png';

  // Colors (hex)
  static const int WALK_TO_COLOR = 0xFF2196F3; // blue
  static const int TRANSIT_COLOR = 0xFFF44336; // red
  static const int WALK_FROM_COLOR = 0xFF4CAF50; // green

  static const List<int> DASH_ARRAY = [6, 6];
}
