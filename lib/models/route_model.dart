import 'package:uuid/uuid.dart';
import 'lat_lng.dart';
import 'leg_model.dart';

class RouteModel {
  final String id;
  final LatLng origin;
  final LatLng destination;
  final List<LegModel> legs;
  double totalDistanceMeters;
  int totalDurationSeconds;
  final DateTime createdAt;

  RouteModel({
    String? id,
    required this.origin,
    required this.destination,
    this.legs = const [],
    double? totalDistanceMeters,
    int? totalDurationSeconds,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        totalDistanceMeters = totalDistanceMeters ?? 0.0,
        totalDurationSeconds = totalDurationSeconds ?? 0,
        createdAt = createdAt ?? DateTime.now().toUtc();

  Map<String, dynamic> toJson() => {
        'id': id,
        'origin': origin.toJson(),
        'destination': destination.toJson(),
        'legs': legs.map((l) => l.toJson()).toList(),
        'totalDistanceMeters': totalDistanceMeters,
        'totalDurationSeconds': totalDurationSeconds,
        'createdAt': createdAt.toIso8601String(),
      };

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final origin = LatLng.fromJson(json['origin'] as Map<String, dynamic>);
    final dest =
        LatLng.fromJson(json['destination'] as Map<String, dynamic>);
    final legs = <dynamic>[];
    if (json['legs'] is List) {
      legs.addAll(json['legs'] as List);
    }
    final legModels = legs
        .whereType<Map<String, dynamic>>()
        .map((m) => LegModel.fromJson(m))
        .toList();
    return RouteModel(
      id: json['id'] as String?,
      origin: origin,
      destination: dest,
      legs: legModels,
      totalDistanceMeters:
          (json['totalDistanceMeters'] as num?)?.toDouble() ?? 0.0,
      totalDurationSeconds: (json['totalDurationSeconds'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String).toUtc()
          : DateTime.now().toUtc(),
    );
  }

  void computeTotals() {
    totalDistanceMeters = legs.fold<double>(0.0, (sum, l) => sum + l.distanceMeters);
    totalDurationSeconds = legs.fold<int>(0, (sum, l) => sum + l.durationSeconds);
  }
}
