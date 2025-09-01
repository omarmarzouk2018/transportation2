import 'lat_lng.dart';

enum LegType { walk_to, transit, walk_from }

class LegModel {
  final LegType type;
  final double distanceMeters;
  final int durationSeconds;
  final List<LatLng> geometry;
  final String? startStationId;
  final String? endStationId;

  LegModel({
    required this.type,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.geometry,
    this.startStationId,
    this.endStationId,
  });

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'distanceMeters': distanceMeters,
        'durationSeconds': durationSeconds,
        'geometry': geometry.map((e) => e.toJson()).toList(),
        'startStationId': startStationId,
        'endStationId': endStationId,
      };

  factory LegModel.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'walk_to';
    final type = LegType.values.firstWhere((e) => e.name == typeStr,
        orElse: () => LegType.walk_to,);
    final geometry = <LatLng>[];
    if (json['geometry'] is List) {
      for (final p in json['geometry'] as List) {
        if (p is Map) {
          geometry.add(LatLng.fromJson(p as Map<String, dynamic>));
        }
      }
    }
    return LegModel(
      type: type,
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble() ?? 0.0,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      geometry: geometry,
      startStationId: json['startStationId'] as String?,
      endStationId: json['endStationId'] as String?,
    );
  }

  String getDurationHumanReadable() {
    final minutes = (durationSeconds / 60).round();
    return '$minutes دقيقة';
  }
}
