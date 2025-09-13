import 'package:flutter/material.dart';
import '../data/stations_data.dart';
import '../models/route_model.dart';
import '../services/routing_service.dart';
import '../services/storage_service.dart';
import '../data/stations_repository.dart';
import '../models/lat_lng.dart';
import '../models/station_model.dart';

class RouteProvider extends ChangeNotifier {
  final RoutingService _routing = RoutingService.instance;
  final StorageService _storage = StorageService.instance;

  LatLng? _destination;
  LatLng? get destination => _destination;

  RouteModel? activeRoute;
  bool isLoading = false;
  List<RouteModel> favorites = [];

  void setDestination(LatLng dest) {
    _destination = dest;
    notifyListeners();
  }

  void clearDestination() {
    _destination = null;
    notifyListeners();
  }

  Future<void> calculateAndSetRoute(LatLng destination) async {
    isLoading = true;
    notifyListeners();
    try {
      final origin = await Future.value(
          StationsRepository.getLastKnownLocation() ??
              LatLng(31.2001, 29.9187));
      // final stations = await StationsRepository.loadStations();
      final stations = StationsData.stationsList;
      final boarding = _routing.findNearestStation(origin, stations);
      final alight = _routing.findNearestStation(destination, stations);
      final route = await _routing.composeMultiLegRoute(
          origin, destination, boarding, alight);
      activeRoute = route;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveActiveRouteAsFavorite(String name) async {
    if (activeRoute == null) return;
    await _storage.saveFavoriteRoute(activeRoute!);
    await loadFavorites();
  }

  Future<void> loadFavorites() async {
    // favorites = await _storage.getFavoriteRoutes();
    notifyListeners();
  }

  List<Map<String, dynamic>> getLegSummary() {
    if (activeRoute == null) return [];
    return activeRoute!.legs.map((l) {
      return {
        'legType': l.type.name,
        'distanceMeters': l.distanceMeters,
        'durationSeconds': l.durationSeconds,
        'startStationId': l.startStationId,
        'endStationId': l.endStationId,
      };
    }).toList();
  }
}
