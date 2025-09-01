import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/lat_lng.dart';
import '../models/route_model.dart';
import '../models/leg_model.dart';
import '../models/station_model.dart';
import '../config/app_config.dart';

class RoutingService {
  RoutingService._internal();
  static final RoutingService instance = RoutingService._internal();

  Future<LegModel> _parseORSFeature(Map<String, dynamic> feature, LegType type,
      {String? startStationId, String? endStationId,}) async {
    final props = feature['properties'] as Map<String, dynamic>? ?? {};
    final summary = props['summary'] as Map<String, dynamic>? ?? {};
    final distance = (summary['distance'] as num?)?.toDouble() ??
        (feature['distance'] as num?)?.toDouble() ??
        0.0;
    final duration = (summary['duration'] as num?)?.toInt() ??
        (feature['duration'] as num?)?.toInt() ??
        0;
    final geometry = feature['geometry'] as Map<String, dynamic>? ?? {};
    final coords = geometry['coordinates'] as List? ?? [];
    final points = <LatLng>[];
    for (final c in coords) {
      if (c is List && c.length >= 2) {
        points.add(LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()));
      }
    }
    return LegModel(
      type: type,
      distanceMeters: distance,
      durationSeconds: duration,
      geometry: points,
      startStationId: startStationId,
      endStationId: endStationId,
    );
  }

  Future<LegModel> calculateRouteORS(
      List<LatLng> waypoints, String profile,) async {
    final url =
        Uri.parse('https://api.openrouteservice.org/v2/directions/$profile/geojson');
    final coords = waypoints.map((w) => [w.longitude, w.latitude]).toList();
    final body = jsonEncode({
      'coordinates': coords,
      'instructions': false,
      'units': 'm',
    });

    int tries = 0;
    while (tries < 3) {
      tries++;
      final resp = await http.post(url, headers: {
        'Authorization': AppConfig.orsApiKey,
        'Content-Type': 'application/json',
      }, body: body,);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final features = (data['features'] as List?) ?? [];
        if (features.isNotEmpty) {
          return _parseORSFeature(features.first as Map<String, dynamic>, LegType.walk_to);
        }
      } else if (resp.statusCode == 403 || resp.statusCode == 429) {
        // rate-limited or forbidden - fallback to OSRM
        return calculateRouteOSRM(waypoints, profile);
      } else {
        await Future.delayed(Duration(milliseconds: 500 * pow(2, tries).toInt()));
      }
    }
    // fallback default empty leg
    return LegModel(
        type: LegType.walk_to,
        distanceMeters: 0.0,
        durationSeconds: 0,
        geometry: [],);
  }

  Future<LegModel> calculateRouteOSRM(List<LatLng> waypoints, String profile) async {
    final coords = waypoints.map((w) => '${w.longitude},${w.latitude}').join(';');
    final url = Uri.parse('${AppConfig.osrmBaseUrl}/route/v1/$profile/$coords?overview=full&geometries=geojson');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final routes = data['routes'] as List? ?? [];
      if (routes.isNotEmpty) {
        final route = routes.first as Map<String, dynamic>;
        final distance = (route['distance'] as num?)?.toDouble() ?? 0.0;
        final duration = (route['duration'] as num?)?.toInt() ?? 0;
        final geometry = route['geometry'] as Map<String, dynamic>? ?? {};
        final coordsList = geometry['coordinates'] as List? ?? [];
        final points = <LatLng>[];
        for (final c in coordsList) {
          if (c is List && c.length >= 2) {
            points.add(LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()));
          }
        }
        return LegModel(
            type: LegType.walk_to,
            distanceMeters: distance,
            durationSeconds: duration,
            geometry: points,);
      }
    }
    return LegModel(
        type: LegType.walk_to,
        distanceMeters: 0.0,
        durationSeconds: 0,
        geometry: [],);
  }

  Future<RouteModel> composeMultiLegRoute(LatLng origin, LatLng destination,
      StationModel boardingStation, StationModel alightStation,) async {
    final legA = await calculateRouteORS([origin, boardingStation.location], 'foot-walking');
    final legB = await calculateRouteORS([boardingStation.location, alightStation.location], 'driving-car');
    final legC = await calculateRouteORS([alightStation.location, destination], 'foot-walking');

    final walkTo = LegModel(
      type: LegType.walk_to,
      distanceMeters: legA.distanceMeters,
      durationSeconds: legA.durationSeconds,
      geometry: legA.geometry,
      startStationId: null,
      endStationId: boardingStation.id,
    );
    final transit = LegModel(
      type: LegType.transit,
      distanceMeters: legB.distanceMeters,
      durationSeconds: legB.durationSeconds,
      geometry: legB.geometry,
      startStationId: boardingStation.id,
      endStationId: alightStation.id,
    );
    final walkFrom = LegModel(
      type: LegType.walk_from,
      distanceMeters: legC.distanceMeters,
      durationSeconds: legC.durationSeconds,
      geometry: legC.geometry,
      startStationId: alightStation.id,
      endStationId: null,
    );

    final route = RouteModel(
      origin: origin,
      destination: destination,
      legs: [walkTo, transit, walkFrom],
    );
    route.computeTotals();
    return route;
  }

  StationModel findNearestStation(LatLng point, List<StationModel> stations) {
    StationModel? nearest;
    double minDist = double.infinity;
    for (final s in stations) {
      final d = s.location.distanceTo(point);
      if (d < minDist) {
        minDist = d;
        nearest = s;
      }
    }
    return nearest!;
  }
}
