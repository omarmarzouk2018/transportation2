import '../models/lat_lng.dart';

class StationsRepository {
//   static Future<List<StationModel>> loadStations() async {
//     final jsonStr = await rootBundle.loadString('assets/stations.json');
//     final list = jsonDecode(jsonStr) as List;
//     return list
//         .map((e) => StationModel.fromJson(Map<String, dynamic>.from(e)))
//         .toList();
//   }

//   static Future<void> updateStationsFromRemote(String url) async {
//     // Not implemented for demo. Would fetch via http and replace cached file or internal storage.
//   }

  static LatLng? getLastKnownLocation() {
    // For demo return a fixed central Alexandria point
    return LatLng(31.21564, 29.95527);
  }
}
