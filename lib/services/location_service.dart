import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../models/lat_lng.dart';
import '../config/constants.dart';

class TrackingStatus {
  final LatLng position;
  final double speedMps;
  final String mode;

  TrackingStatus({
    required this.position,
    required this.speedMps,
    required this.mode,
  });
}

class LocationService {
  LocationService._internal();
  static final LocationService instance = LocationService._internal();

  final StreamController<TrackingStatus> _statusController =
      StreamController.broadcast();

  Stream<TrackingStatus> get statusStream => _statusController.stream;

  Position? _lastPosition;
  StreamSubscription<Position>? _sub;
  double currentSpeedMps = 0.0;
  LatLng? currentPosition;
  String currentMode = 'ثابت';

  Future<bool> _ensurePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<void> startTracking() async {
    final ok = await _ensurePermission();
    if (!ok) {
      throw Exception('Location permission denied');
    }

    final settings = const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1,
    );

    _sub?.cancel();
    _sub = Geolocator.getPositionStream(locationSettings: settings)
        .listen((pos) {
      _processPosition(pos);
    }, onError: (e) {
      // ignore errors for now
    },);
  }

  Future<void> stopTracking() async {
    await _sub?.cancel();
    _sub = null;
  }

  Future<LatLng> getCurrentPosition() async {
    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),);
    final ll = LatLng(pos.latitude, pos.longitude);
    currentPosition = ll;
    currentSpeedMps = pos.speed.isFinite ? pos.speed : 0.0;
    currentMode = _modeFromSpeed(currentSpeedMps);
    return ll;
  }

  void _processPosition(Position pos) {
    final now = DateTime.now().toUtc();
    final newLatLng = LatLng(pos.latitude, pos.longitude);
    double speed = pos.speed.isFinite ? pos.speed : 0.0;
    if (!pos.speed.isFinite && _lastPosition != null) {
      final last = _lastPosition!;
      final lastTime = last.timestamp ?? now;
      final diff = pos.timestamp.difference(lastTime).inMilliseconds ?? 1000;
      final dist = LatLng(last.latitude, last.longitude).distanceTo(newLatLng);
      final sec = diff / 1000;
      if (sec > 0) {
        speed = dist / sec;
      }
    }
    _lastPosition = pos;
    currentPosition = newLatLng;
    currentSpeedMps = speed;
    currentMode = _modeFromSpeed(speed);
    final status = TrackingStatus(
      position: newLatLng,
      speedMps: speed,
      mode: currentMode,
    );
    _statusController.add(status);
  }

  String _modeFromSpeed(double speed) {
    if (speed < Constants.STATIONARY_THRESHOLD) {
      return 'ثابت';
    } else if (speed < Constants.WALKING_THRESHOLD) {
      return 'مشي';
    } else {
      return 'قيادة';
    }
  }
}
