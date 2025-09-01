import 'dart:async';
import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../models/lat_lng.dart';

class TrackingProvider extends ChangeNotifier {
  final LocationService _location = LocationService.instance;
  StreamSubscription<TrackingStatus>? _sub;

  bool isTracking = false;
  LatLng? currentPosition;
  double currentSpeedMps = 0.0;
  String currentMode = 'ثابت';

  void start() async {
    try {
      await _location.startTracking();
      _sub = _location.statusStream.listen((status) {
        currentPosition = status.position;
        currentSpeedMps = status.speedMps;
        currentMode = status.mode;
        notifyListeners();
      });
      isTracking = true;
      notifyListeners();
    } catch (_) {
      isTracking = false;
      notifyListeners();
    }
  }

  void stop() async {
    await _sub?.cancel();
    _sub = null;
    await _location.stopTracking();
    isTracking = false;
    notifyListeners();
  }

  void toggle() {
    if (isTracking) {
      stop();
    } else {
      start();
    }
  }
}
