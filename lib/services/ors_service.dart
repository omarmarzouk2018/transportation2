import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

Future<List<List<double>>> getRouteFromORS({
  required List<double> start, // [lng, lat]
  required List<double> end, // [lng, lat]
  List<List<double>>? waypoints, // optional
}) async {
  final apiKey = AppConfig.orsApiKey;

  final url = Uri.parse(
      'https://api.openrouteservice.org/v2/directions/driving-car/geojson');

  final body = {
    "coordinates": [
      start,
      if (waypoints != null) ...waypoints,
      end,
    ]
  };

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": apiKey,
    },
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final coords = data["features"][0]["geometry"]["coordinates"] as List;
    print(coords);
    // coords = [ [lng, lat], [lng, lat], ... ]
    return coords
        .map<List<double>>((c) => [
              (c[1] as num).toDouble(), // lat
              (c[0] as num).toDouble(), // lng
            ])
        .toList();
  } else {
    throw Exception("error from ORS: ${response.body}");
  }
}

// (array) eg.: [[8.681495,49.41461],[8.686507,49.41943],[8.687872,49.420318]]
// The waypoints to use for the route as an array of longitude/latitude pairs in WGS 84 (EPSG:4326)
