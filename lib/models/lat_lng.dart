import 'dart:math';

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);

  Map<String, dynamic> toJson() => {
        'lat': latitude,
        'lon': longitude,
      };

  factory LatLng.fromJson(Map<String, dynamic> json) {
    final lat = (json['lat'] ?? json['latitude'] ?? json['lat']) as num?;
    final lon = (json['lon'] ?? json['longitude'] ?? json['lon']) as num?;
    return LatLng((lat ?? 0).toDouble(), (lon ?? 0).toDouble());
  }

  double distanceTo(LatLng other) {
    // Haversine formula
    const earthRadius = 6371000.0; // meters
    final dLat = _toRadians(other.latitude - latitude);
    final dLon = _toRadians(other.longitude - longitude);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(latitude)) *
            cos(_toRadians(other.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double _toRadians(double degree) => degree * pi / 180.0;

  @override
  bool operator ==(Object other) =>
      other is LatLng &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() => 'LatLng($latitude, $longitude)';
}
